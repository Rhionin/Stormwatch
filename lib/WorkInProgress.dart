class WorkInProgress {
  String title;
  int progress;
  int prevProgress;

  WorkInProgress();

  WorkInProgress.withArgs(String title, int progress) {
    this.title = title;
    this.progress = progress;
  }

  WorkInProgress.withAllArgs(String title, int progress, int prevProgress) {
    this.title = title;
    this.progress = progress;
    this.prevProgress = prevProgress;
  }

  WorkInProgress.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        progress = json['progress'] ?? 0,
        prevProgress = json['prevProgress'];

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
