import 'package:flutter_test/flutter_test.dart';
import 'package:stormwatch/work_in_progress.dart';

void main() {
	group('Work In Progress from JSON', () {
		var cases = [{
			'title': 'Empty JSON',
			'json': Map<String, dynamic>(),
			'expected': WorkInProgress.withAllArgs('', 0, null),
		}, {
			'title': 'Full object',
			'json': {
				'title': 'Book 1',
				'progress': 50,
				'prevProgress': 25,
			},
			'expected': WorkInProgress.withAllArgs('Book 1', 50, 25),
		}, {
			'title': 'Input has title and progress only',
			'json': {
				'title': 'Book 1',
				'progress': 50,
			},
			'expected': WorkInProgress.withAllArgs('Book 1', 50, null),
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
			'jsonStr': '{}',
			'expected': WorkInProgress.withAllArgs('', 0, null),
		}, {
			'title': 'Full object',
			'jsonStr': '{"title":"Book 1", "progress":50, "prevProgress": 25}',
			'expected': WorkInProgress.withAllArgs('Book 1', 50, 25),
		}, {
			'title': 'Input has title and progress only',
			'jsonStr': '{"title":"Book 1", "progress": 50}',
			'expected': WorkInProgress.withAllArgs('Book 1', 50, null),
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