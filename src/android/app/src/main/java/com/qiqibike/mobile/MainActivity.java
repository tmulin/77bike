package com.qiqibike.mobile;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private final String UPDATE_CHANNEL = "com.77bike.mobile/update";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(this.getFlutterView(), UPDATE_CHANNEL).setMethodCallHandler(new UpdateChannel(getApplicationContext()));
    }
}
