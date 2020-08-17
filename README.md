# Flutter Ogury SDK

**Unofficial** plugin for integrating the Ogury SDK. Currently only supports **interstitial ads!** Please be aware that major changes could be coming.

## Installation

### iOS

Make sure to set the deployment target to iOS 10.0 inside you Podfile!

```pod
platform :ios, '10.0'
```

### iOS and Android

Go to your Ogury Dashboard and [register your application](https://help.publishers.ogury.co/hc/en-us/articles/360023634651-Register-your-Assets#Add%20Android%20Or%20IOS%20app). Note down **asset key**.

Create an [Interstitial ad unit](https://oguryhelp.zendesk.com/hc/en-us/articles/360003462837) and note down the **ad unit id**.


Add the plugin to your **pubspec.yaml**

```yaml
flutter_ogury: ^0.1.1
```

## Usage

Initialise the Ogury SDK preferably inside the **main.dart**.
```dart
/// Initialises the Ogury SDK
  FlutterOgury.initialize(
    assetKeyAndroid: "OGY-XXXXXXXXXXXX",
    assetKeyIOS: "OGY-XXXXXXXXXXXX",
  );
```

Load the sdk as soon as possible
```dart
FlutterOgury.loadInterstitial(
      adUnitIdAndroid: "123456_default",
      adUnitIdIOS: "123456_default",
      enableTestAd: true,
    );
```

Check if the interstitial ad has been loaded
```dart
bool interstitialIsLoaded = await FlutterOgury.interstitialIsLoaded();
```

Show the interstitial ad
```dart
FlutterOgury.showInterstitial();
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)