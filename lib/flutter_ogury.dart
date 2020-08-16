import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ogury/models/interstitial_ad_status.dart';
import 'package:meta/meta.dart';
export 'package:flutter_ogury/models/interstitial_ad_status.dart';

class FlutterOgury {
  static const MethodChannel _channel =
  const MethodChannel('flutter_ogury');

  static const _interstitialChannel = const MethodChannel("flutter_ogury/interstitialAd");

  static void Function(InterstitialAdStatus, dynamic) listener;

  /// This method must be called before all the other ones to initialize the Ogury sdk!
  /// Copy the Asset Key from the Asset details inside you Ogury Dashboard
  /// The Asset Key follows the pattern: OGY-XXXXXXXXXXXX,
  /// where X is an uppercase letter or digit.
  static Future<bool> initialize({@required String assetKeyAndroid,@required String assetKeyIOS}) async {
    String assetKey = Platform.isIOS ? assetKeyIOS : assetKeyAndroid;
    await _channel.invokeMethod('init',assetKey);
    _interstitialChannel.setMethodCallHandler(_handleEvent);
    return true;
  }

  /// Starts loading an interstitial ad.
  /// Since it may take a few seconds to fetch the ad resources (video, image, ...)
  /// from the network, you should call the load method as soon as possible
  /// Set [enableTestAd] to true if you want to enable test ads
  /// iOS: https://docs.ogury.co/ios/test-your-implementation#step-1-get-your-device-iphone-advertising-id-idfa
  /// Android: https://docs.ogury.co/android/test-your-implementation#step-1-get-your-device-google-advertising-id-aaid
  static Future<bool> loadInterstitial({@required String adUnitIdAndroid,@required String adUnitIdIOS, enableTestAd = false}) async {
    String adUnitId = Platform.isIOS ? adUnitIdIOS : adUnitIdAndroid;
    adUnitId += enableTestAd ? "_test" : "";
    final bool version = await _interstitialChannel.invokeMethod('load_interstitial', adUnitId);
    return version;
  }

  /// Shows an interstitial ad if an ad is available
  /// (if the interstitial status is InterstitialAdStatus.AdLoaded)
  static Future<bool> showInterstitial() async {
    final bool version = await _interstitialChannel.invokeMethod('show_interstitial');
    return version;
  }

  ///Call the following method to check if an Interstitial Ad is ready to be displayed:
  static Future<bool> interstitialIsLoaded() async {
    return await _interstitialChannel.invokeMethod('interstitial_is_loaded');
  }

  /// Handles native method calls
  static Future<dynamic> _handleEvent(MethodCall call) {
    print("method called");
    print(call.method);
    switch (call.method) {
      case "InterstitialAdResult.AdAvailable":
        listener(InterstitialAdStatus.AdAvailable, null);
        break;
      case "InterstitialAdResult.AdNotAvailable":
        listener(InterstitialAdStatus.AdNotAvailable, null);
        break;
      case "InterstitialAdResult.AdLoaded":
        listener(InterstitialAdStatus.AdLoaded, null);
        break;
      case "InterstitialAdResult.AdNotLoaded":
        listener(InterstitialAdStatus.AdNotLoaded, null);
        break;
      case "InterstitialAdResult.AdDisplayed":
        listener(InterstitialAdStatus.AdDisplayed, null);
        break;
      case "InterstitialAdResult.AdClosed":
        listener(InterstitialAdStatus.AdClosed, null);
        break;
      case "InterstitialAdResult.AdError":
        listener(InterstitialAdStatus.AdError, call.arguments);
        break;
      default:
        print("${call.method} ${call.arguments}");
    }
    return Future.value(true);
  }
}
