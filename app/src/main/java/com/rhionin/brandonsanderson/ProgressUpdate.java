package com.rhionin.brandonsanderson;

public class ProgressUpdate {

    private WorkInProgress[] wips;

    public ProgressUpdate() {

    }

    public ProgressUpdate(WorkInProgress[] wips) {
        setWips(wips);
    }

    public WorkInProgress[] getWips() {
        return wips;
    }

    public void setWips(WorkInProgress[] wips) {
        this.wips = wips;
    }

}
