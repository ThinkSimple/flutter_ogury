package com.thinksimple.flutter_ogury;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.presage.common.AdConfig;
import io.presage.interstitial.PresageInterstitial;
import io.presage.interstitial.PresageInterstitialCallback;

public class FlutterOguryInterstitialAdPlugin implements MethodChannel.MethodCallHandler {

    private PresageInterstitial interstitial;

    private Context context;
    private MethodChannel channel;

    public FlutterOguryInterstitialAdPlugin(Context context, MethodChannel channel, Activity activity) {
        this.context = context;
        this.channel = channel;
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "load_interstitial":
                result.success(_initInterstitial((String) call.arguments));
                break;
            case "show_interstitial":
                result.success(showInterstitial());
                break;
            case "interstitial_is_loaded":
                result.success(interstitialIsLoaded());
                break;
            default:
                result.notImplemented();
        }

    }

    private boolean _initInterstitial(String adUnitId) {

        AdConfig config = new AdConfig(adUnitId);
        interstitial = new PresageInterstitial(this.context, config);
        interstitial.setInterstitialCallback(new PresageInterstitialCallback() {
            @Override
            public void onAdAvailable() {
                channel.invokeMethod("InterstitialAdResult.AdAvailable", null);
            }

            @Override
            public void onAdNotAvailable() {
                channel.invokeMethod("InterstitialAdResult.AdNotAvailable", null);

            }

            @Override
            public void onAdLoaded() {
                Log.d("Moin", "onAdLoaded");
                channel.invokeMethod("InterstitialAdResult.AdLoaded", null);

            }

            @Override
            public void onAdNotLoaded() {
                channel.invokeMethod("InterstitialAdResult.AdNotLoaded", null);
            }

            @Override
            public void onAdDisplayed() {
                channel.invokeMethod("InterstitialAdResult.AdDisplayed", null);

            }

            @Override
            public void onAdClosed() {
                channel.invokeMethod("InterstitialAdResult.AdClosed", null);

            }

            @Override
            public void onAdError(int i) {
                channel.invokeMethod("InterstitialAdResult.AdError", i);

            }

            ;
// ...
        });

        interstitial.load();
        return true;
    }


    private boolean showInterstitial() {
        if (interstitial.isLoaded()) {
            interstitial.show();
        } else {
            Log.d("Ogury", "Interstitial not loaded!");
        }
        return true;
    }

    private boolean interstitialIsLoaded() {
        return interstitial.isLoaded();
    }
}
