class WorkInProgress {
  String title;
  int progress;
  int prevProgress;

  WorkInProgress();

  WorkInProgress.withArgs(String title, int progress) {
    this.title = title;
    this.progress = progress;
  }

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
