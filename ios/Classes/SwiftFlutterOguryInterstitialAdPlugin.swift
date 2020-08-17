import Foundation
import OguryAds
import OguryChoiceManager
import Flutter
import UIKit

public class FlutterOguryInterstitialAdPlugin: NSObject, OguryAdsInterstitialDelegate {
    
    let channel: FlutterMethodChannel
    var interstitial: OguryAdsInterstitial?
    var interstitialLoaded: Bool = false
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        
        super.init()
        
        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "load_interstitial":
                result(self.loadAd(call))
                break;
            case "show_interstitial":
                result(self.showAd())
                break;
            case "interstitial_is_loaded":
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
        
        self.interstitial!.interstitialDelegate = self
        self.interstitial!.load()
        return true
    }
    
    public func showAd() -> Bool {
        if ((self.interstitial?.isLoaded) != nil){
            self.interstitial?.show(in: (UIApplication.shared.keyWindow?.rootViewController)!)
        } else {
            print(self.interstitial.debugDescription)
            print("Ad could not be shown")
            return false
        }
        return true
    }
    
    public func interstitialIsLoaded() -> Bool {
        /*
         //currently interstitial.isLoaded is not really working 
         print("isLoaded:")
         print(self.interstitial?.isLoaded)
         return self.interstitial?.isLoaded ?? false
         */
        return interstitialLoaded
    }
    
    public func oguryAdsInterstitialAdAvailable() {
        interstitialLoaded = false
        self.channel.invokeMethod("InterstitialAdResult.AdAvailable",arguments: nil)
        
    }
    
    public func oguryAdsInterstitialAdNotAvailable() {
        interstitialLoaded = false
        self.channel.invokeMethod("InterstitialAdResult.AdNotAvailable",arguments: nil)
    }
    
    public func oguryAdsInterstitialAdLoaded() {
        interstitialLoaded = true
        self.channel.invokeMethod("InterstitialAdResult.AdLoaded",arguments: nil)
    }
    
    public func oguryAdsInterstitialAdNotLoaded() {
        interstitialLoaded = false
        self.channel.invokeMethod("InterstitialAdResult.AdNotLoaded",arguments: nil)
        
    }
    
    public func oguryAdsInterstitialAdDisplayed() {
        interstitialLoaded = false
        self.channel.invokeMethod("InterstitialAdResult.AdDisplayed",arguments: nil)
        
    }
    
    public func oguryAdsInterstitialAdClosed() {
        interstitialLoaded = false
        self.channel.invokeMethod("InterstitialAdResult.AdClosed",arguments: nil)
    }
    
    public func oguryAdsInterstitialAdError(_ errorType: OguryAdsErrorType) {
        interstitialLoaded = false
        self.channel.invokeMethod("InterstitialAdResult.AdError",arguments: "InterstitialAdResult.AdError")
        
    }
}
