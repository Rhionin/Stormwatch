import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stormwatch/work_in_progress.dart';
import 'package:stormwatch/progress_update.dart';

void main() {
	group('Progress Update', () {

		var cases = [{
			'title': 'empty message',
			'message': Map<String, dynamic>(),
			'expected': [],
		}, {
			'title': 'empty worksInProgress',
			'message': {
				'data': {
					'worksInProgress': jsonEncode([]),
				},
			},
			'expected': [],
		}, {
			'title': 'one entry in worksInProgress',
			'message': {
				'data': {
					'worksInProgress': jsonEncode([{
						"title":"Book 1", "progress":25, "prevProgress":0,
					}]),
				},
			},
			'expected': [
				WorkInProgress.withAllArgs("Book 1", 25, 0),
			],
		}, {
			'title': 'many entries in worksInProgress',
			'message': {
				'data': {
					'worksInProgress': jsonEncode([{
						"title":"Book 1", "progress":25, "prevProgress":0,
					}, {
						"title":"Book 2", "progress":50, "prevProgress":25,
					}, {
						"title":"Book 3", "progress":100,
					}]),
				},
			},
			'expected': [
				WorkInProgress.withAllArgs("Book 1", 25, 0),
				WorkInProgress.withAllArgs("Book 2", 50, 25),
				WorkInProgress.withAllArgs("Book 3", 100, null),
			],
		}];

		cases.forEach((c) {
			test(c['title'], () {
				List expected = c['expected'];
				List<WorkInProgress> actualResult = worksInProgressFromMessage(c['message']);

				expect(actualResult.length, expected.length, reason: "Actual result length (${actualResult.length}) mismatches expected result length (${expected.length})");

				for (int i = 0; i < actualResult.length; i++) {
					WorkInProgress res = actualResult[i];
					WorkInProgress exp = expected[i];

					expect(res.getTitle(), exp.getTitle());
					expect(res.getProgress(), exp.getProgress());
					expect(res.getPrevProgress(), exp.getPrevProgress());
				}
			});
		});
	});
}