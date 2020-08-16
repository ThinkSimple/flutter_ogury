import Flutter
import UIKit
import OguryAds
import OguryChoiceManager

public class SwiftFlutterOguryPlugin: NSObject, FlutterPlugin {
    
    let channel: FlutterMethodChannel
    
    init(_ channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "flutter_ogury", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterOguryPlugin(channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        
        let interstitialAdChannel: FlutterMethodChannel = FlutterMethodChannel.init(name: "flutter_ogury/interstitialAd", binaryMessenger: registrar.messenger())
        _ = FlutterOguryInterstitialAdPlugin.init(channel: interstitialAdChannel)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
        case "init":
            result(self.initializeOgury(call))
            break;
        default:
            print("method call not found")
            result(nil)
        }
    }
    
    public func initializeOgury(_ call: FlutterMethodCall) -> Bool{
        print("called initializeOgury")
        let assetKey: String = call.arguments as! String
        OguryChoiceManager.shared().setup(withAssetKey: assetKey, andConfig: OguryChoiceManagerConfig.default())
        OguryChoiceManager.shared().ask(with: (UIApplication.shared.keyWindow?.rootViewController)!) { (error, response) in
            OguryAds.shared().setup(withAssetKey: assetKey)
        }
        
        return true;
    }
    
}
