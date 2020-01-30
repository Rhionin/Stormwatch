import "dart:convert";

class WorkInProgress {
  String title;
  int progress;
  int prevProgress;

  WorkInProgress({this.title = "", this.progress = 0, this.prevProgress = 0});

  WorkInProgress.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        progress = json['progress'] ?? 0,
        prevProgress = json['prevProgress'] ?? 0;

  WorkInProgress.fromJsonString(String jsonStr)
      : this.fromJson(jsonDecode(jsonStr));

  Map<String, dynamic> toJson() =>
  {
    'title': title,
    'progress': progress,
    'prevProgress': prevProgress,
  };

  int getProgress() {
    return progress;
  }

  void setProgress(int progress) {
    this.progress = progress;
  }

  String getTitle() {
    return title;
  }

  void setTitle(String title) {
    this.title = title;
  }

  int getPrevProgress() {
    return prevProgress;
  }

  void setPrevProgress(intprevProgress) {
    this.prevProgress = prevProgress;
  }
}
