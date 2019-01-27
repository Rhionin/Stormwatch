package com.rhionin.brandonsanderson;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.android.gms.gcm.GcmListenerService;

import com.rhionin.brandonsanderson.R;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import static com.rhionin.brandonsanderson.WorksInProgressActivity.PROGRESS_TOPIC;
import static com.rhionin.brandonsanderson.WorksInProgressActivity.WIPS_CACHE_FILE;
import static com.rhionin.brandonsanderson.WorksInProgressActivity.WIPS_UPDATED;
import static com.rhionin.brandonsanderson.WorksInProgressActivity.WORKS_IN_PROGRESS;

public class MyGcmListenerService extends GcmListenerService {

    private static final String TAG = "MyGcmListenerService";

    /**
     * Called when message is received.
     *
     * @param from SenderID of the sender.
     * @param data Data bundle containing message data as key/value pairs.
     *             For Set of keys use data.keySet().
     */
    // [START receive_message]
    @Override
    public void onMessageReceived(String from, Bundle data) {
        if (from.equals(PROGRESS_TOPIC)) {
            try {
                File wipsCache = new File(getCacheDir(), WIPS_CACHE_FILE);
                if (!wipsCache.exists()) {
                    wipsCache.createNewFile();
                }

                String wipsStr = data.getString(WORKS_IN_PROGRESS);
                FileOutputStream outputStream = new FileOutputStream(wipsCache);
                outputStream.write(wipsStr.getBytes());
                outputStream.close();

                Intent wipsUpdated = new Intent(WIPS_UPDATED);
                LocalBroadcastManager.getInstance(this).sendBroadcast(wipsUpdated);

//                Log.d(TAG, "From: " + from);
                sendNotification(getString(R.string.app_name), "Brandon Sanderson posted a progress update");

            } catch (IOException e) {
//                Log.e(TAG, "Can't create works in progress cache file in application external cache directory");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    // [END receive_message]

    /**
     * Create and show a simple notification containing the received GCM message.
     *
     * @param title Title of the GCM message.
     * @param message GCM message received.
     */
    private void sendNotification(String title, String message) {
        Intent intent = new Intent(this, WorksInProgressActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                PendingIntent.FLAG_ONE_SHOT);

        Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.ic_stat_ic_notification)
                .setContentTitle(title)
                .setContentText(message)
                .setAutoCancel(true)
                .setSound(defaultSoundUri)
                .setContentIntent(pendingIntent);

        NotificationManager notificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        notificationManager.notify(0 /* ID of notification */, notificationBuilder.build());
    }
}
