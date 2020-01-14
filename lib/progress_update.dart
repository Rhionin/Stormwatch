import 'package:stormwatch/WorkInProgress.dart';

Iterable<WorkInProgress> worksInProgressFromMessage(Map<String, dynamic> message) {
	Map<String, List> messageData = message['data'] ?? Map<String, List>();
	List worksInProgressList = messageData['worksInProgress'] ?? [];
	return worksInProgressList.map((wip) {
		return WorkInProgress.fromJson(wip);
	});
}