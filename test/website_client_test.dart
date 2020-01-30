import 'package:flutter_test/flutter_test.dart';
import 'package:stormwatch/work_in_progress.dart';
import 'package:stormwatch/website_client.dart';

void main() {
	group('parseWorkInProgress', () {

		var cases = [{
			'input': 'Stormlight 4 & 5 Outlining 100%',
			'expected': WorkInProgress(title: 'Stormlight 4 & 5 Outlining', progress: 100),
		}];

		cases.forEach((c) {
			test(c['title'], () {
				String input = c['input'];
				WorkInProgress expected = c['expected'];

				WorkInProgress actualResult = parseWorkInProgress(input);

				expect(actualResult.getTitle(), expected.getTitle());
				expect(actualResult.getProgress(), expected.getProgress());
				expect(actualResult.getPrevProgress(), expected.getPrevProgress());
			});
		});
	});
}