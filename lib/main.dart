import 'package:flutter/material.dart';
import 'package:stormwatch/work_in_progress.dart';
import 'package:stormwatch/progress_update.dart';
import 'package:stormwatch/progress_storage.dart';
import 'package:stormwatch/website_client.dart';
import 'package:stormwatch/storm_watch_icons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyApp());

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
	final prefs = await SharedPreferences.getInstance();
	prefs.setString("backgroundMessage", json.encode(message));

	if (message.containsKey('data')) {
		// Handle data message
		final dynamic data = message['data'];
		print("data: $data");
	}

	if (message.containsKey('notification')) {
		// Handle notification message
		final dynamic notification = message['notification'];
		print("notification: $notification");
	}

	// Or do other work.
	var wipsStr = prefs.getString("worksInProgress");
	print("backgroundhandler wipsStr: $wipsStr");
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
				await setWorksInProgressStr(message['data']['worksInProgress']);
				_getAndRenderWips();
			},
			onLaunch: (Map<String, dynamic> message) async {
				print("onLaunch: $message");
				setWorksInProgressStr(message['data']['worksInProgress']);
			},
			onResume: (Map<String, dynamic> message) async {
				print("onResume: $message");
				setWorksInProgressStr(message['data']['worksInProgress']);
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

	List<Card> _wipCards = [];
//  List<Card> _wipCards = [Card(
//    child: Column(
//      children: <Widget>[
//        ListTile(title: Text("Book 1!!")),
//        LinearProgressIndicator(
//            value: 1,
//            backgroundColor: Colors.green,
//        ),
//      ],
//    )
//  )];

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
			body: Center(
				// Center is a layout widget. It takes a single child and positions it
				// in the middle of the parent.
				child: Column(
					// Column is also a layout widget. It takes a list of children and
					// arranges them vertically. By default, it sizes itself to fit its
					// children horizontally, and tries to be as tall as its parent.
					//
					// Invoke "debug painting" (press "p" in the console, choose the
					// "Toggle Debug Paint" action from the Flutter Inspector in Android
					// Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
					// to see the wireframe for each widget.
					//
					// Column has various properties to control how it sizes itself and
					// how it positions its children. Here we use mainAxisAlignment to
					// center the children vertically; the main axis here is the vertical
					// axis because Columns are vertical (the cross axis would be
					// horizontal).
					children: _wipCards,
				),
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () async {
					List<WorkInProgress> wips = await getWorksInProgressFromWebsite();
					setWorksInProgress(wips);
					_renderWips(wips);
				},
				child: Icon(Icons.refresh),
				backgroundColor: Colors.green,
			),
		);
	}
}

void debugPrintWrapped(String text) {
	final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
	pattern.allMatches(text).forEach((match) => print(match.group(0)));
}