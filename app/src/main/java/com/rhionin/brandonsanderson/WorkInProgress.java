package com.rhionin.brandonsanderson;

/**
 *
 */
public class WorkInProgress {

    private String title;
    private Integer progress;
    private Integer prevProgress;

    public WorkInProgress() {
    }

    public WorkInProgress(String title, int progress) {
        this.title = title;
        this.progress = progress;
    }

    public Integer getProgress() {
        return progress;
    }

    public void setProgress(Integer progress) {
        this.progress = progress;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getPrevProgress() {
        return prevProgress;
    }

    public void setPrevProgress(Integer prevProgress) {
        this.prevProgress = prevProgress;
    }
}
