import 'package:flutter/foundation.dart';
import 'package:futu/src/services/ad_service.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/services/storage_service.dart';

class InterstitialAdHelper {
  static final InterstitialAdHelper _instance =
      InterstitialAdHelper._internal();
  factory InterstitialAdHelper() => _instance;
  InterstitialAdHelper._internal();

  static InterstitialAdHelper get instance => _instance;

  // Ad frequency control
  static const int _minTimeBetweenAds = 60; // seconds
  static const int _maxAdsPerSession = 5;

  int _adsShownThisSession = 0;
  DateTime? _lastAdShown;

  /// Shows an interstitial ad if conditions are met
  Future<bool> showAdIfAppropriate({
    required String placement,
    bool forceShow = false,
  }) async {
    // Don't show ads in debug mode unless forced
    if (kDebugMode && !forceShow) {
      if (kDebugMode) print('Skipping ad in debug mode for $placement');
      return false;
    }

    // Check if we've hit session limit
    if (_adsShownThisSession >= _maxAdsPerSession && !forceShow) {
      if (kDebugMode) print('Session ad limit reached for $placement');
      return false;
    }

    // Check time between ads
    if (_lastAdShown != null && !forceShow) {
      final timeSinceLastAd = DateTime.now()
          .difference(_lastAdShown!)
          .inSeconds;
      if (timeSinceLastAd < _minTimeBetweenAds) {
        if (kDebugMode) print('Too soon since last ad for $placement');
        return false;
      }
    }

    // Check if ad is ready
    if (!AdService.instance.isInterstitialAdReady) {
      if (kDebugMode) print('Interstitial ad not ready for $placement');
      return false;
    }

    // Show the ad
    final adShown = await AdService.instance.showInterstitialAd(
      placement: placement,
    );

    if (adShown) {
      _adsShownThisSession++;
      _lastAdShown = DateTime.now();

      // Track ad analytics
      await AnalyticsService.instance.logAdImpression(
        'interstitial',
        placement,
      );

      if (kDebugMode) print('Interstitial ad shown for $placement');
    }

    return adShown;
  }

  /// Reset session counters (call when app starts)
  void resetSession() {
    _adsShownThisSession = 0;
    _lastAdShown = null;
  }

  /// Get remaining ads for this session
  int get remainingAdsThisSession =>
      (_maxAdsPerSession - _adsShownThisSession).clamp(0, _maxAdsPerSession);
}
