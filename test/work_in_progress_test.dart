import 'package:flutter_test/flutter_test.dart';
import 'package:stormwatch/WorkInProgress.dart';

void main() {
	group('Work In Progress from JSON', () {
		var cases = [{
			'title': 'Empty JSON',
			'json': Map<String, dynamic>(),
			'expected': WorkInProgress.withAllArgs('', 0, 0),
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
			'expected': WorkInProgress.withAllArgs('Book 1', 50, 0),
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
}