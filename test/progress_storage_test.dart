import 'package:flutter_test/flutter_test.dart';
import 'package:stormwatch/progress_storage.dart';
import 'package:stormwatch/work_in_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
	group('setWorksInProgress', () {

		var cases = [{
			'title': 'empty list',
			'worksInProgress': <WorkInProgress>[],
			'expected': '[]',
		}, {
			'title': 'one element, default args',
			'worksInProgress': <WorkInProgress>[
				new WorkInProgress(),
			],
			'expected': '[{"title":"","progress":0,"prevProgress":0}]',
		}, {
			'title': 'one element',
			'worksInProgress': <WorkInProgress>[
				new WorkInProgress(title: "Book 1", progress: 50, prevProgress: 0),
			],
			'expected': '[{"title":"Book 1","progress":50,"prevProgress":0}]',
		}, {
			'title': 'many elements',
			'worksInProgress': <WorkInProgress>[
				new WorkInProgress(title: "Book 1", progress: 50, prevProgress: 0),
				new WorkInProgress(title: "Book 2", progress: 100, prevProgress: 0),
			],
			'expected': '[{"title":"Book 1","progress":50,"prevProgress":0},{"title":"Book 2","progress":100,"prevProgress":0}]',
		}];

		cases.forEach((c) {
			test(c['title'], () async {
				SharedPreferences.setMockInitialValues({});

				String expectedWips = c['expected'];
				List<WorkInProgress> wips = c['worksInProgress'];

				await setWorksInProgress(wips);

				SharedPreferences prefs = await SharedPreferences.getInstance();
				String actualWips = prefs.getString('worksInProgress');

				expect(actualWips, expectedWips);
			});
		});
	});

	group('getWorksInProgress', () {

		var cases = [{
			'title': 'null value in storage',
			'expected': <WorkInProgress>[],
			'worksInProgress': null,
		}, {
			'title': 'empty list',
			'expected': <WorkInProgress>[],
			'worksInProgress': '[]',
		}, {
			'title': 'one element, default args',
			'expected': <WorkInProgress>[
				new WorkInProgress(),
			],
			'worksInProgress': '[{"title":"","progress":0,"prevProgress":null}]',
		}, {
			'title': 'one element',
			'expected': <WorkInProgress>[
				new WorkInProgress(title: "Book 1", progress: 50, prevProgress: 0),
			],
			'worksInProgress': '[{"title":"Book 1","progress":50,"prevProgress":0}]',
		}, {
			'title': 'many elements',
			'expected': <WorkInProgress>[
				new WorkInProgress(title: "Book 1", progress: 50, prevProgress: 0),
				new WorkInProgress(title: "Book 2", progress: 100, prevProgress: 0),
			],
			'worksInProgress': '[{"title":"Book 1","progress":50,"prevProgress":0},{"title":"Book 2","progress":100,"prevProgress":null}]',
		}];

		cases.forEach((c) {
			test(c['title'], () async {
				SharedPreferences.setMockInitialValues({
					'worksInProgress': c['worksInProgress'],
				});

				List<WorkInProgress>expectedWips = c['expected'];

				var actualWips = await getWorksInProgress();

				expect(actualWips.length, expectedWips.length, reason: "Actual result length (${actualWips.length}) mismatches expected result length (${expectedWips.length})");

				for (int i = 0; i < actualWips.length; i++) {
					WorkInProgress res = actualWips[i];
					WorkInProgress exp = expectedWips[i];

					expect(res.getTitle(), exp.getTitle());
					expect(res.getProgress(), exp.getProgress());
					expect(res.getPrevProgress(), exp.getPrevProgress());
				}
			});
		});
	});
}