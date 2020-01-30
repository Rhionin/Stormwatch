import 'package:flutter_test/flutter_test.dart';
import 'package:stormwatch/work_in_progress.dart';
import 'dart:convert';

void main() {
	group('Work In Progress from JSON', () {
		var cases = [{
			'title': 'Empty JSON',
			'json': Map<String, dynamic>(),
			'expected': WorkInProgress(title: '', progress: 0, prevProgress: 0),
		}, {
			'title': 'Full object',
			'json': {
				'title': 'Book 1',
				'progress': 50,
				'prevProgress': 25,
			},
			'expected': WorkInProgress(title: 'Book 1', progress: 50, prevProgress: 25),
		}, {
			'title': 'Input has title and progress only',
			'json': {
				'title': 'Book 1',
				'progress': 50,
			},
			'expected': WorkInProgress(title: 'Book 1', progress: 50, prevProgress: 0),
		}];

		cases.forEach((c) {
			test(c['title'], () {
				WorkInProgress expected = c['expected'];

				var actualResult = WorkInProgress.fromJson(c['json']);
				expect(actualResult.getTitle(), expected.getTitle());
				expect(actualResult.getProgress(), expected.getProgress());
				expect(actualResult.getPrevProgress(), expected.getPrevProgress());
			});
		});
	});

	group('Work In Progress from JSON string', () {
		var cases = [{
			'title': 'Empty JSON',
			'jsonStr': jsonEncode({}),
			'expected': WorkInProgress(title: '', progress: 0, prevProgress: 0),
		}, {
			'title': 'Full object',
			'jsonStr': jsonEncode({"title":"Book 1", "progress":50, "prevProgress": 25}),
			'expected': WorkInProgress(title: 'Book 1', progress: 50, prevProgress: 25),
		}, {
			'title': 'Input has title and progress only',
			'jsonStr': jsonEncode({"title":"Book 1", "progress": 50}),
			'expected': WorkInProgress(title: 'Book 1', progress: 50, prevProgress: 0),
		}];

		cases.forEach((c) {
			test(c['title'], () {
				WorkInProgress expected = c['expected'];

				var actualResult = WorkInProgress.fromJsonString(c['jsonStr']);
				expect(actualResult.getTitle(), expected.getTitle());
				expect(actualResult.getProgress(), expected.getProgress());
				expect(actualResult.getPrevProgress(), expected.getPrevProgress());
			});
		});
	});
}