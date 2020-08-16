import Foundation
import OguryAds
import OguryChoiceManager
import Flutter
import UIKit

public class FlutterOguryInterstitialAdPlugin: NSObject, OguryAdsInterstitialDelegate {
    
    let channel: FlutterMethodChannel
    var interstitial: OguryAdsInterstitial?
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        
        super.init()
        
        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "load_interstitial":
                print("load interstitial called")
                result(self.loadAd(call))
                break;
            case "show_interstitial":
                print("show interstitial called")
                result(self.showAd())
                break;
            case "interstitial_is_loaded":
                print("interstitialIsLoaded called")
                result(self.interstitialIsLoaded())
                break;
            default:
                print("call not found")
            }
        }
    }
    
    public func loadAd(_ call: FlutterMethodCall) -> Bool {
        print("loadAd called")
        let adUnit: String = call.arguments as! String
        self.interstitial = OguryAdsInterstitial.init(adUnitID: adUnit)
        
        interstitial!.interstitialDelegate = self
        self.interstitial!.load()
        return true
    }
    
    public func showAd() -> Bool {
        if ((self.interstitial?.isLoaded) != nil){
            print("interstitial shown")
            self.interstitial?.show(in: (UIApplication.shared.keyWindow?.rootViewController)!)
        } else {
            print(self.interstitial.debugDescription)
            print("Ad could not be shown")
            return false
        }
        return true
    }
    
    public func interstitialIsLoaded() -> Bool {
        print("isLoaded:")
        print(self.interstitial?.isLoaded)
        return self.interstitial?.isLoaded ?? false
    }
    
    public func oguryAdsInterstitialAdAvailable() {
        print("oguryAdsInterstitialAdAvailable")
        self.channel.invokeMethod("InterstitialAdResult.AdAvailable",arguments: nil)
        
    }
    
    public func oguryAdsInterstitialAdNotAvailable() {
        print("oguryAdsInterstitialAdNotAvailable")
        self.channel.invokeMethod("InterstitialAdResult.AdNotAvailable",arguments: nil)
    }
    
    public func oguryAdsInterstitialAdLoaded() {
        print("oguryAdsInterstitialAdLoaded")
        self.channel.invokeMethod("InterstitialAdResult.AdLoaded",arguments: nil)
    }
    
    public func oguryAdsInterstitialAdNotLoaded() {
        print("oguryAdsInterstitialAdNotLoaded")
        self.channel.invokeMethod("InterstitialAdResult.AdNotLoaded",arguments: nil)
        
    }
    
    public func oguryAdsInterstitialAdDisplayed() {
        print("oguryAdsInterstitialAdDisplayed")
        self.channel.invokeMethod("InterstitialAdResult.AdDisplayed",arguments: nil)
        
    }
    
    public func oguryAdsInterstitialAdClosed() {
        print("oguryAdsInterstitialAdClosed")
        self.channel.invokeMethod("InterstitialAdResult.AdClosed",arguments: nil)
        self.interstitial?.isLoaded.toggle()
        print(self.interstitial?.isLoaded)
    }
    
    public func oguryAdsInterstitialAdError(_ errorType: OguryAdsErrorType) {
        print("oguryAdsInterstitialAdError")
        self.channel.invokeMethod("InterstitialAdResult.AdError",arguments: "InterstitialAdResult.AdError")
        
    }
}
