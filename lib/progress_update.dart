import 'dart:convert';

import 'package:stormwatch/work_in_progress.dart';

Iterable<WorkInProgress> worksInProgressFromMessage(Map<String, dynamic> message) {
	Map<String, String> messageData = message['data'] ?? Map<String, String>();
	String worksInProgressStr = messageData['worksInProgress'] ?? '[]';
	List worksInProgressList = jsonDecode(worksInProgressStr);
	return worksInProgressList.map((wip) {
		return WorkInProgress.fromJson(wip);
	});
}