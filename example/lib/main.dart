import 'package:flutter/material.dart';
import 'package:flutter_ogury/flutter_ogury.dart';

void main() {
  runApp(MyApp());

  /// Initializes the Ogury SDK
  FlutterOgury.initialize(
    assetKeyAndroid: "OGY-48BE01AF311F",
    assetKeyIOS: "OGY-42589A8E8E42",
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  ///Load the sdk as soon as possible
  void _loadInterstitialAd() {
    FlutterOgury.loadInterstitial(
      adUnitIdAndroid: "300700_default",
      adUnitIdIOS: "300745_default",
      enableTestAd: true,
    );
  }

  void _showAd() async {
    bool interstitialIsLoaded = await FlutterOgury.interstitialIsLoaded();

    if (interstitialIsLoaded) {
      FlutterOgury.showInterstitial();
    }

    FlutterOgury.loadInterstitial(
      adUnitIdAndroid: "300700_default",
      adUnitIdIOS: "300745_default",
      enableTestAd: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Flutter Ogury Example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                  child: Text("Load"),
                  onPressed: () {
                    _loadInterstitialAd();
                  }),
              RaisedButton(
                  child: Text("Show"),
                  onPressed: () {
                    //FlutterOgury.showInterstitial();
                    _showAd();
                  }),
              RaisedButton(
                  child: Text("isLoaded"),
                  onPressed: () async {
                    bool isLoaded = await FlutterOgury.interstitialIsLoaded();
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text("$isLoaded")));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

