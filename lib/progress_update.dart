import 'dart:convert';

import 'package:stormwatch/work_in_progress.dart';

List<WorkInProgress> worksInProgressFromMessage(Map<String, dynamic> message) {
	Map<String, String> messageData = (message['data'] ?? new Map<String, dynamic>())
		.cast<String, String>();
	String worksInProgressStr = messageData['worksInProgress'] ?? '[]';
	List worksInProgressList = jsonDecode(worksInProgressStr);
	return worksInProgressList.map((wip) {
		return WorkInProgress.fromJson(wip);
	}).toList(growable: false);
}