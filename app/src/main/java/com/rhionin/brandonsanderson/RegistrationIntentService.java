package com.rhionin.brandonsanderson;

import android.app.IntentService;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Debug;
import android.preference.PreferenceManager;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;


import com.google.firebase.messaging.FirebaseMessaging;

public class RegistrationIntentService extends IntentService {

    private static final String TAG = "RegIntentService";

    public static final String PROGRESS_TOPIC = "progress";
    public static final String DEV_PROGRESS_TOPIC = "devprogress";

    public RegistrationIntentService() {
        super(TAG);
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this);

        try {
            // [START register_for_gcm]
            // Initially this call goes out to the network to retrieve the token, subsequent calls
            // are local.
            // R.string.gcm_defaultSenderId (the Sender ID) is typically derived from google-services.json.
            // See https://developers.google.com/cloud-messaging/android/start for details on this file.

            // Subscribe to topic channels
            subscribeTopics();

            // You should store a boolean that indicates whether the generated token has been
            // sent to your server. If the boolean is false, send the token to your server,
            // otherwise your server should have already received the token.
            sharedPreferences.edit().putBoolean(QuickstartPreferences.SENT_TOKEN_TO_SERVER, true).apply();
            // [END register_for_gcm]
        } catch (Exception e) {
            Log.d(TAG, "Failed to complete token refresh", e);
            // If an exception happens while fetching the new token or updating our registration data
            // on a third-party server, this ensures that we'll attempt the update at a later time.
            sharedPreferences.edit().putBoolean(QuickstartPreferences.SENT_TOKEN_TO_SERVER, false).apply();
        }
        // Notify UI that registration has completed, so the progress indicator can be hidden.
        Intent registrationComplete = new Intent(QuickstartPreferences.REGISTRATION_COMPLETE);
        LocalBroadcastManager.getInstance(this).sendBroadcast(registrationComplete);
    }

    /**
     * Subscribe to any FCM topics of interest, as defined by the TOPICS constant.
     */
    // [START subscribe_topics]
    private void subscribeTopics() {
        Log.d(TAG, "Subscribing to topic: "+PROGRESS_TOPIC);
        FirebaseMessaging.getInstance().subscribeToTopic(PROGRESS_TOPIC);

        if (Debug.isDebuggerConnected()) {
            Log.d(TAG, "Subscribing to topic: "+DEV_PROGRESS_TOPIC);
            FirebaseMessaging.getInstance().subscribeToTopic(DEV_PROGRESS_TOPIC);
        }
    }
    // [END subscribe_topics]

}
