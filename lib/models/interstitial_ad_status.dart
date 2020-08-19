enum InterstitialAdStatus {
  AdAvailable,
  AdNotAvailable,
  AdLoaded,
  AdNotLoaded,
  AdDisplayed,
  AdClosed,
  AdError
}

/// AdAvailable
/// The ad server has provided an ad to the SDK. The SDK will start caching the assets.
///
/// AdNotAvailable
/// The ad server does not have an ad to present to the user.
/// Note that during the integration, you can force the Ogury SDK to always
/// display a test ad. More details can be found in the test ad section.
/// https://docs.ogury.co/ios/test-your-implementation
///
/// AdLoaded
/// The SDK is ready to display the ad provided by the ad server.
///
/// AdNotLoaded
/// The ad failed to display because it was not fully loaded when the show method was called.
///
/// AdDisplayed
/// The ad has been displayed on the screen.
///
/// AdClosed
/// The ad has been closed by the user.
///
/// AdError
/// The ad failed to load or display.
/// The errorCode parameter contains the reason of the failure.
/// Error codes: https://docs.ogury.co/ios/ad-formats/interstitial-ad#error-codes
