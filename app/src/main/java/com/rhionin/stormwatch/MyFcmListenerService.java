package com.rhionin.stormwatch;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Map;

import static com.rhionin.stormwatch.ProgressService.WORKS_IN_PROGRESS;
import static com.rhionin.stormwatch.RegistrationIntentService.DEV_PROGRESS_TOPIC;
import static com.rhionin.stormwatch.RegistrationIntentService.PROGRESS_TOPIC;

public class MyFcmListenerService extends FirebaseMessagingService {

    private static final String TAG = "MyFcmListenerService";

    /**
     * Called when message is received.
     *
     * @param from SenderID of the sender.
     * @param data Data bundle containing message data as key/value pairs.
     *             For Set of keys use data.keySet().
     */
    // [START receive_message]
    @Override
    public void onMessageReceived(RemoteMessage message) {
        String from = message.getFrom();
        Map data = message.getData();
        if (from.equals(PROGRESS_TOPIC) || from.equals(DEV_PROGRESS_TOPIC)) {
            String wipsStr = data.get(WORKS_IN_PROGRESS).toString();
            ProgressService.setWorksInProgress(this, wipsStr);
        }
    }
    // [END receive_message]
}
