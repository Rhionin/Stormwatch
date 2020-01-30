import 'dart:convert';

import 'package:stormwatch/work_in_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> setWorksInProgress(List<WorkInProgress> wips) async {
	SharedPreferences prefs = await SharedPreferences.getInstance();
	String wipsStr = jsonEncode(wips);
	return prefs.setString('worksInProgress', wipsStr);
}

Future<List<WorkInProgress>> getWorksInProgress() async {
	SharedPreferences prefs = await SharedPreferences.getInstance();
	String wipsStr = prefs.getString('worksInProgress');
	List<dynamic> jsonList = jsonDecode(wipsStr);
	return jsonList
		.map((dynamic m) => WorkInProgress.fromJson(m))
		.toList();
}