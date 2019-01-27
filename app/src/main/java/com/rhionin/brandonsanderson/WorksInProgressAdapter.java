package com.rhionin.brandonsanderson;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;

/**
 * Created by cjc on 3/14/16.
 */
public class WorksInProgressAdapter extends RecyclerView.Adapter<WorksInProgressAdapter.CustomViewHolder> {
    private WorkInProgress[] mWorksInProgress;

//    // Provide a reference to the views for each data item
//    // Complex data items may need more than one view per item, and
//    // you provide access to all the views for a data item in a view holder
//    public static class ViewHolder extends RecyclerView.ViewHolder {
//        // each data item is just a string in this case
//        public TextView mTextView;
//        public ViewHolder(View v) {
//            super(v);
//            mTextView = v;
//        }
//    }

    // Provide a suitable constructor (depends on the kind of dataset)
    public WorksInProgressAdapter(WorkInProgress[] wips) {
        mWorksInProgress = wips;
    }

    // Create new views (invoked by the layout manager)
    @Override
    public CustomViewHolder onCreateViewHolder(ViewGroup parent,
                                                   int viewType) {
        // create a new view
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.list_row, parent, false);
        // set the view's size, margins, paddings and layout parameters
//        ...
        CustomViewHolder vh = new CustomViewHolder(v);
        return vh;
    }

    // Replace the contents of a view (invoked by the layout manager)
    @Override
    public void onBindViewHolder(CustomViewHolder holder, int position) {
        // - get element from your dataset at this position
        // - replace the contents of the view with that element
        holder.titleView.setText(mWorksInProgress[position].getTitle());

        if (mWorksInProgress[position].getPrevProgress() != null &&
                mWorksInProgress[position].getPrevProgress() != 0) {
            holder.progressTextView.setText(String.format("(%d%% -> %d%%)",
                    mWorksInProgress[position].getPrevProgress(),
                    mWorksInProgress[position].getProgress()));
        } else {
            holder.progressTextView.setText(String.format("(%d%%)", mWorksInProgress[position].getProgress()));
        }
        holder.progressBar.setProgress(mWorksInProgress[position].getProgress());
    }

    // Return the size of your dataset (invoked by the layout manager)
    @Override
    public int getItemCount() {
        return mWorksInProgress.length;
    }

    public class CustomViewHolder extends RecyclerView.ViewHolder {
        protected TextView titleView;
        protected TextView progressTextView;
        protected ProgressBar progressBar;

        public CustomViewHolder(View view) {
            super(view);
            this.titleView = (TextView) view.findViewById(R.id.title);
            this.progressTextView = (TextView) view.findViewById(R.id.progressText);
            this.progressBar = (ProgressBar) view.findViewById(R.id.progressBar);
        }
    }
}
