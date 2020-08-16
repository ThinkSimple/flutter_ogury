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


  private Activity mActivity;
  private Context mContext;
  private FlutterOguryInterstitialAdPlugin interstitialAdPlugin;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

    Log.d("Moin", "onAttachedToEngine started");

    this.mContext = flutterPluginBinding.getApplicationContext();
    // Main channel for initialization
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(),
            "flutter_ogury");
    channel.setMethodCallHandler(this);

    final MethodChannel interstitialAdChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(),
            "flutter_ogury/interstitialAd");
    interstitialAdPlugin = new FlutterOguryInterstitialAdPlugin(flutterPluginBinding.getApplicationContext(),
            interstitialAdChannel,null);
    interstitialAdChannel
            .setMethodCallHandler(interstitialAdPlugin);
  }

  public void registerWith(PluginRegistry.Registrar registrar) {
    Log.d("Moin", "registerWith started");

    this.mContext = registrar.context();
    this.mActivity = registrar.activity();
    // Main channel for initialization
    final MethodChannel channel = new MethodChannel(registrar.messenger(),
            "flutter_ogury");
    channel.setMethodCallHandler(this);

    final MethodChannel interstitialAdChannel = new MethodChannel(registrar.messenger(),
            "flutter_ogury/interstitialAd");
    interstitialAdPlugin = new FlutterOguryInterstitialAdPlugin(registrar.context(),
            interstitialAdChannel,registrar.activity());
    interstitialAdChannel
            .setMethodCallHandler(interstitialAdPlugin);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    Log.d("Moin", "onMethodCall started");

    if (call.method.equals("init")) {
      init((String) call.arguments);
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  private boolean init(final String assetKey) {

    Log.d("Moin", "init started");

    OguryChoiceManager.initialize(this.mContext, assetKey, new OguryCmConfig());

    final OguryConsentListener oguryConsentListener = new OguryConsentListener() {
      @Override
      public void onComplete(OguryChoiceManager.Answer answer) {
        Log.d("Moin", "OguryConsentListener onComplete");
        startSdks(assetKey);
      }

      @Override
      public void onError(OguryError error) {
        Log.d("Moin", error.getMessage());
        Log.d("Moin", "OguryConsentListener onError " + error.toString());

        startSdks(assetKey);
      }
    };

    OguryChoiceManager.ask(this.mActivity, oguryConsentListener);

    Presage.getInstance().start(assetKey, this.mContext);

    return true;
  }

  private void startSdks(String assetKey) {
    Log.d("Moin", "startSdks");
    Presage.getInstance().start(assetKey, this.mContext);
    // start vendors' SDKs
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    Log.d("Moin", "onDetachedFromEngine started");

    //channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    Log.d("Moin", "onAttachedToActivity started");
    Log.d("Moin", binding.getActivity().toString());
    this.mActivity = binding.getActivity();
    //interstitialAdPlugin.setActivity(this.mActivity);

  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    Log.d("Moin", "onDetachedFromActivityForConfigChanges started");

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    Log.d("Moin", "onReattachedToActivityForConfigChanges started");


  }

  @Override
  public void onDetachedFromActivity() {
    Log.d("Moin", "onDetachedFromActivity started");


  }
}