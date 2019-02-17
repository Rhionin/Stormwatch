package com.rhionin.brandonsanderson;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import static com.rhionin.brandonsanderson.ProgressService.WIPS_CACHE_FILE;

public class WorksInProgressActivity extends AppCompatActivity {

    private static final String PROGRESS_URL = "https://www.brandonsanderson.com";
    private static final String TAG = "WorksInProgressActivity";

    public static String PROGRESS_TOPIC = "/topics/progress";
    public static String WIPS_UPDATED = "wipsUpdated";
    public static String WORKS_IN_PROGRESS = "worksInProgress";
    private boolean isReceiverRegistered;
    private BroadcastReceiver mWipsBroadcastReceiver;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_works_in_progress);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        mWipsBroadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                displayProgress();
            }
        };

        displayProgress();
    }

    @Override
    protected void onResume() {
        super.onResume();
        registerReceiver();
    }

    @Override
    protected void onPause() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(mWipsBroadcastReceiver);
        isReceiverRegistered = false;
        super.onPause();
    }

    private void registerReceiver(){
        if(!isReceiverRegistered) {
            LocalBroadcastManager.getInstance(this).registerReceiver(mWipsBroadcastReceiver,
                    new IntentFilter(WIPS_UPDATED));
            isReceiverRegistered = true;
        }
    }

    private void getAndDisplayProgressFromWeb() {
        ConnectivityManager connMgr = (ConnectivityManager)
                getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
        if (networkInfo != null && networkInfo.isConnected()) {
            new DownloadWebpageTask().execute(PROGRESS_URL);
        } else {
            System.err.println("No network connection. Cannot get latest progress.");
        }
    }

    // Uses AsyncTask to create a task away from the main UI thread. This task takes a
    // URL string and uses it to create an HttpUrlConnection. Once the connection
    // has been established, the AsyncTask downloads the contents of the webpage as
    // an InputStream. Finally, the InputStream is converted into a string, which is
    // displayed in the UI by the AsyncTask's onPostExecute method.
    private class DownloadWebpageTask extends AsyncTask<String, Void, Document> {
        @Override
        protected Document doInBackground(String... urls) {
            Document doc = null;
            try {
                doc = Jsoup.connect(urls[0]).get();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return doc;
        }

        // onPostExecute displays the results of the AsyncTask.
        @Override
        protected void onPostExecute(Document result) {
            WorkInProgress[] wips = getWorksInProgressFromPage(result);
            ProgressUpdate progress = new ProgressUpdate(wips);
            displayProgress(progress);
        }
    }

    private WorkInProgress[] getWorksInProgressFromPage(Document doc) {
        Element progressTitles = doc.select("#pagewrap .progress-titles")
                .first();

        Elements bookTitles = progressTitles.select(".book-title");
        Elements progressPercentages = progressTitles.select(".progress");

        WorkInProgress[] wips = new WorkInProgress[bookTitles.size()];
        for(int i = 0; i < bookTitles.size(); i++) {
            String title = bookTitles.get(i).text();
            int progress = Integer.parseInt(progressPercentages.get(i).text().split(" ")[0]);

            wips[i] = new WorkInProgress(title, progress);
        }

        return wips;
    }

    private void displayProgress() {
        ProgressUpdate progress = ProgressService.getProgressUpdateFromFile(this);
        if (progress != null) {
            displayProgress(progress);
        } else {
            getAndDisplayProgressFromWeb();
        }
    }

    private void displayProgress(ProgressUpdate progress) {
        RecyclerView mWipsCardsView = (RecyclerView) findViewById(R.id.wips_cards);
        mWipsCardsView.setHasFixedSize(true);

        RecyclerView.LayoutManager mWipsLayoutManager = new LinearLayoutManager(this);
        mWipsCardsView.setLayoutManager(mWipsLayoutManager);

        RecyclerView.Adapter mAdapter = new WorksInProgressAdapter(progress.getWips());
        mWipsCardsView.setAdapter(mAdapter);
    }
}
