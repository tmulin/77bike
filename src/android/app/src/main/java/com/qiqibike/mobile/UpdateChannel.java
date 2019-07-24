package com.qiqibike.mobile;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.core.content.FileProvider;

import java.io.File;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class UpdateChannel implements MethodChannel.MethodCallHandler {
    private static final String TAG = UpdateChannel.class.getName();

    private Context appContext;

    public UpdateChannel(Context context) {
        this.appContext = context;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "installApplicationPackage":
                handleInstallApplicationPackage(methodCall, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void handleInstallApplicationPackage(MethodCall methodCall, MethodChannel.Result result) {
        Log.d(TAG, "handleInstallApplicationPackage: ++");

        String apkFilePath = methodCall.argument("apkFile");

        Log.i(TAG, "handleInstallApplicationPackage: APK = " + apkFilePath);

        if (apkFilePath == null || apkFilePath == "") {
            result.success(false);
        } else {

            File apkFile = new File(apkFilePath);
            Log.d(TAG, "handleInstallApplicationPackage: APK FILE => LENGTH : " + apkFile.length());
            Intent intent = new Intent();
            intent.setAction(Intent.ACTION_VIEW);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                Uri contentUri = FileProvider.getUriForFile(appContext, "com.qiqibike.mobile.fileProvider.update", apkFile);
                intent.setDataAndType(contentUri, "application/vnd.android.package-archive");
            } else {
                intent.setDataAndType(Uri.fromFile(apkFile), "application/vnd.android.package-archive");
            }
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            appContext.startActivity(intent);

            result.success(true);
        }
        Log.d(TAG, "handleInstallApplicationPackage: --");
    }
}
