import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:futu/src/services/analytics_service.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  static AdService get instance => _instance;

  // Test Ad Unit IDs (replace with real ones when you get AdMob account)
  static final String _bannerAdUnitId = kDebugMode
      ? (Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111' // Test banner Android
            : 'ca-app-pub-3940256099942544/2934735716') // Test banner iOS
      : (Platform.isAndroid
            ? 'ca-app-pub-YOUR_PUBLISHER_ID/YOUR_BANNER_AD_UNIT_ID' // Your real banner Android
            : 'ca-app-pub-YOUR_PUBLISHER_ID/YOUR_BANNER_AD_UNIT_ID'); // Your real banner iOS

  static final String _interstitialAdUnitId = kDebugMode
      ? (Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712' // Test interstitial Android
            : 'ca-app-pub-3940256099942544/4411468910') // Test interstitial iOS
      : (Platform.isAndroid
            ? 'ca-app-pub-YOUR_PUBLISHER_ID/YOUR_INTERSTITIAL_AD_UNIT_ID' // Your real interstitial Android
            : 'ca-app-pub-YOUR_PUBLISHER_ID/YOUR_INTERSTITIAL_AD_UNIT_ID'); // Your real interstitial iOS

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
  }

  // Banner Ad Creation
  BannerAd createBannerAd({required String placement}) {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (kDebugMode) print('Banner ad loaded for $placement');
          AnalyticsService.instance.logAdImpression('banner', placement);
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) print('Banner ad failed to load for $placement: $error');
          ad.dispose();
        },
        onAdClicked: (ad) {
          AnalyticsService.instance.logAdClick('banner', placement);
        },
      ),
    );
  }

  // Interstitial Ad Management
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          if (kDebugMode) print('Interstitial ad loaded');

          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) print('Interstitial ad failed to load: $error');
          _isInterstitialAdLoaded = false;
          // Retry loading after 30 seconds
          Future.delayed(const Duration(seconds: 30), _loadInterstitialAd);
        },
      ),
    );
  }

  Future<bool> showInterstitialAd({required String placement}) async {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          if (kDebugMode) print('Interstitial ad showed for $placement');
          AnalyticsService.instance.logAdImpression('interstitial', placement);
        },
        onAdDismissedFullScreenContent: (ad) {
          if (kDebugMode) print('Interstitial ad dismissed for $placement');
          ad.dispose();
          _isInterstitialAdLoaded = false;
          // Load next ad
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          if (kDebugMode) print('Interstitial ad failed to show for $placement: $error');
          ad.dispose();
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        },
        onAdClicked: (ad) {
          AnalyticsService.instance.logAdClick('interstitial', placement);
        },
      );

      await _interstitialAd!.show();
      return true;
    } else {
      if (kDebugMode) print('Interstitial ad not ready for $placement');
      return false;
    }
  }

  bool get isInterstitialAdReady => _isInterstitialAdLoaded;

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdLoaded = false;
  }
}
