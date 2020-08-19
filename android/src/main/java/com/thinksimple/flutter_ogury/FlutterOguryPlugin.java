package com.thinksimple.flutter_ogury;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.ogury.cm.OguryChoiceManager;
import com.ogury.cm.OguryCmConfig;
import com.ogury.cm.OguryConsentListener;
import com.ogury.core.OguryError;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.presage.Presage;

/* FlutterOguryPlugin */
public class FlutterOguryPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {


    private static Activity mActivity;
    private static Context mContext;
    private static FlutterOguryInterstitialAdPlugin interstitialAdPlugin;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

        mContext = flutterPluginBinding.getApplicationContext();
        // Main channel for initialization
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(),
                "flutter_ogury");
        channel.setMethodCallHandler(this);

        final MethodChannel interstitialAdChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(),
                "flutter_ogury/interstitialAd");
        interstitialAdPlugin = new FlutterOguryInterstitialAdPlugin(flutterPluginBinding.getApplicationContext(),
                interstitialAdChannel, null);
        interstitialAdChannel
                .setMethodCallHandler(interstitialAdPlugin);
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        mContext = registrar.context();
        mActivity = registrar.activity();
        // Main channel for initialization
        final MethodChannel channel = new MethodChannel(registrar.messenger(),
                "flutter_ogury");
        channel.setMethodCallHandler(new FlutterOguryPlugin());

        final MethodChannel interstitialAdChannel = new MethodChannel(registrar.messenger(),
                "flutter_ogury/interstitialAd");
        interstitialAdPlugin = new FlutterOguryInterstitialAdPlugin(registrar.context(),
                interstitialAdChannel, registrar.activity());
        interstitialAdChannel
                .setMethodCallHandler(interstitialAdPlugin);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

        if (call.method.equals("init")) {
            result.success(init((String) call.arguments));
        } else {
            result.notImplemented();
        }
    }

    private boolean init(final String assetKey) {

        OguryChoiceManager.initialize(mContext, assetKey, new OguryCmConfig());

        final OguryConsentListener oguryConsentListener = new OguryConsentListener() {
            @Override
            public void onComplete(OguryChoiceManager.Answer answer) {
                startSdks(assetKey);
            }

            @Override
            public void onError(OguryError error) {
                Log.d("Ogury", "consent error " + error.toString());
                Log.d("Ogury", error.getMessage());
                startSdks(assetKey);
            }
        };

        OguryChoiceManager.ask(mActivity, oguryConsentListener);

        Presage.getInstance().start(assetKey, mContext);

        return true;
    }

    private void startSdks(String assetKey) {
        Presage.getInstance().start(assetKey, mContext);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
        //interstitialAdPlugin.setActivity(this.mActivity);

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {


    }

    @Override
    public void onDetachedFromActivity() {


    }
}