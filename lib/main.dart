import 'package:flutter/material.dart';
import 'package:stormwatch/work_in_progress.dart';
import 'package:stormwatch/progress_storage.dart';
import 'package:stormwatch/website_client.dart';
import 'package:stormwatch/storm_watch_icons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

var mainApp = MyApp();
void main() => runApp(mainApp);

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
	print("backgroundhandler: $message");
	String wipsStr = message['data']['worksInProgress'];
	if (wipsStr != null) {
		await setWorksInProgressStr(message['data']['worksInProgress']);
	}
}

class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'StormWatch',
			theme: ThemeData(
				// This is the theme of your application.
				//
				// Try running your application with "flutter run". You'll see the
				// application has a blue toolbar. Then, without quitting the app, try
				// changing the primarySwatch below to Colors.green and then invoke
				// "hot reload" (press "r" in the console where you ran "flutter run",
				// or simply save your changes to "hot reload" in a Flutter IDE).
				// Notice that the counter didn't reset back to zero; the application
				// is not restarted.
				primarySwatch: Colors.blue,
			),
			home: WorksInProgressPage(),
		);
	}
}

class WorksInProgressPage extends StatefulWidget {
	WorksInProgressPage({Key key}) : super(key: key);

	// This widget is the home page of your application. It is stateful, meaning
	// that it has a State object (defined below) that contains fields that affect
	// how it looks.

	// This class is the configuration for the state. It holds the values (in this
	// case the title) provided by the parent (in this case the App widget) and
	// used by the build method of the State. Fields in a Widget subclass are
	// always marked "final".

	final String title = 'Works In Progress';

	@override
	_WorksInProgressPageState createState() => _WorksInProgressPageState();
}

class _WorksInProgressPageState extends State<WorksInProgressPage> with SingleTickerProviderStateMixin {
	final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

	@override
	void initState() {
		super.initState();

		_firebaseMessaging.configure(
			onMessage: (Map<String, dynamic> message) async {
				print("onMessage: $message");
				_handleWorksInProgressMessage(message);
			},
			onLaunch: (Map<String, dynamic> message) async {
				print("onLaunch: $message");
				_handleWorksInProgressMessage(message);
			},
			onResume: (Map<String, dynamic> message) async {
				print("onResume: $message");
				_handleWorksInProgressMessage(message);
			},
			onBackgroundMessage: myBackgroundMessageHandler,
		);
		_firebaseMessaging.requestNotificationPermissions(
			const IosNotificationSettings(
				sound: true, badge: true, alert: true, provisional: true));
		_firebaseMessaging.onIosSettingsRegistered
			.listen((IosNotificationSettings settings) {
			print("Settings registered: $settings");
		});
		_firebaseMessaging.getToken().then((String token) {
			assert(token != null);
			print("Push Messaging token: $token");
		});

		_firebaseMessaging.subscribeToTopic("devprogress");
		_firebaseMessaging.subscribeToTopic("progress");

		_getAndRenderWips();
	}

	void _handleWorksInProgressMessage(Map<String, dynamic> message) async {
		String wipsStr = message['data']['worksInProgress'];
		if (wipsStr != null) {
			await setWorksInProgressStr(message['data']['worksInProgress']);
			_getAndRenderWips();
		}
	}

	List<Card> _wipCards = [];
	List<Card> _worksInProgressToCards(List<WorkInProgress> worksInProgress) {

		return worksInProgress.map((w) {
			String wipText = w.getTitle();
			// TODO Right-align percentage text
			if (w.getPrevProgress() != 0) {
				wipText += " (" + w.getPrevProgress().toString() + "% -> " + w.getProgress().toString() + "%)";
			} else {
				wipText += " (" + w.getProgress().toString() + "%)";
			}

			return Card(
				child: Column(
					children: <Widget>[
						ListTile(title: Text(wipText)),
						LinearProgressIndicator(
							value: w.getProgress() / 100,
						),
					],
				),
			);
		}).toList(growable: false);
	}

	void _getAndRenderWips() async {
		List<WorkInProgress> wips = await _getWips();
		_renderWips(wips);
	}

	Future<List<WorkInProgress>> _getWips() async {
		List<WorkInProgress> wips = await getWorksInProgress();
		if (wips.length == 0) {
			wips = await getWorksInProgressFromWebsite();
			setWorksInProgress(wips);
		}
		return wips;
	}

	void _renderWips(List<WorkInProgress> wips) {
		List<Card> wipCards = _worksInProgressToCards(wips);
		setState(() {
			_wipCards = wipCards;
		});
	}

	@override
	Widget build(BuildContext context) {
		// This method is rerun every time setState is called, for instance as done
		// by the _incrementCounter method above.
		//
		// The Flutter framework has been optimized to make rerunning build methods
		// fast, so that you can just rebuild anything that needs updating rather
		// than having to individually change instances of widgets.
		return Scaffold(
			appBar: AppBar(
				leading: Icon(
					StormWatchIcons.bridge_four,
					size: 60,
				),
				// Here we take the value from the MyHomePage object that was created by
				// the App.build method, and use it to set our appbar title.
				title: Text(widget.title),
			),
			body: new RefreshIndicator(
				onRefresh: _refresh,
				child: ListView(
					children: _wipCards,
				),
			),
//			floatingActionButton: FloatingActionButton(
//				onPressed: _refresh,
//				child: Icon(Icons.refresh),
//				backgroundColor: Colors.green,
//			),
		);
	}

	Future<void> _refresh() async {
		List<WorkInProgress> wips = await getWorksInProgressFromWebsite();
		setWorksInProgress(wips);
		_renderWips(wips);
	}
}

void debugPrintWrapped(String text) {
	final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
	pattern.allMatches(text).forEach((match) => print(match.group(0)));
}