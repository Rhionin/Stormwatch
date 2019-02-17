package com.rhionin.brandonsanderson;

// Abstraction layer for getting progress updates

import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import static com.rhionin.brandonsanderson.WorksInProgressActivity.WIPS_UPDATED;

public class ProgressService {

    private static final String TAG = "ProgressService";

    public static String WIPS_CACHE_FILE = "wips.json";

    public static void setWorksInProgress(Context context, String wipsStr) {
        try {
            File wipsCache = getWipsCacheFile(context);
            if (!wipsCache.exists()) {
                wipsCache.createNewFile();
            }

            FileOutputStream outputStream = new FileOutputStream(wipsCache);
            outputStream.write(wipsStr.getBytes());
            outputStream.close();

            Intent wipsUpdated = new Intent(WIPS_UPDATED);
            LocalBroadcastManager.getInstance(context).sendBroadcast(wipsUpdated);
        } catch (IOException e) {
            Log.e(TAG, "Can't create works in progress cache file in application external cache directory");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static ProgressUpdate getProgressUpdateFromFile(Context context) {
        ProgressUpdate progress = null;
        try {
            File wipsCache = getWipsCacheFile(context);
            if (wipsCache.exists()) {
                FileInputStream inputStream = new FileInputStream(wipsCache);
                StringBuilder builder = new StringBuilder();
                int ch;
                while((ch = inputStream.read()) != -1){
                    builder.append((char)ch);
                }
                inputStream.close();

                String wipsStr = builder.toString();
                if (wipsStr.length() > 0) {

                    try {
                        ObjectMapper mapper = new ObjectMapper();
                        WorkInProgress[] wips = mapper.readValue(wipsStr, WorkInProgress[].class);
                        progress = new ProgressUpdate(wips);
                    } catch (IOException ex) {
                        ex.printStackTrace();
                    }
                } else {
                    Log.e(TAG, "No content in the wips cache file");
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return progress;
    }

    private static File getWipsCacheFile(Context context) {
        return new File(context.getCacheDir(), WIPS_CACHE_FILE);
    }
}
