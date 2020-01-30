import 'package:stormwatch/work_in_progress.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

Future<List<WorkInProgress>> getWorksInProgressFromWebsite() async {
	var response = await http.get('https://brandonsanderson.com');
	return parseWorksInProgressFromWebsite(response.body);
}

List<WorkInProgress> parseWorksInProgressFromWebsite(String websiteHTML) {
	var document = parse(websiteHTML);
	var progressDiv = document.querySelector(".wpb_wrapper .vc_progress_bar");
	var progressEntrySelectors = progressDiv.querySelectorAll(".vc_label");
	var progressEntries = progressEntrySelectors.map((pe) {
		return pe.text;
	});

	return progressEntries.map((pe) {
		return parseWorkInProgress(pe);
	}).toList(growable: false);
}

RegExp workInProgressRegexp = new RegExp(r"^(.*)+ ([\d]+)%$");
WorkInProgress parseWorkInProgress(String wipString) {
	wipString = wipString.trim();

	Match match = workInProgressRegexp.firstMatch(wipString);

	String title = match.group(1).trim();
	int progress = int.parse(match.group(2).trim());

	return WorkInProgress(title: title, progress: progress);
}