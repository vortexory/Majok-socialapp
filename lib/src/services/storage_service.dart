import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static StorageService get instance => _instance;

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // App State
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keyLanguage = 'selected_language';

  bool get isFirstLaunch => _prefs?.getBool(_keyFirstLaunch) ?? true;

  Future<void> setFirstLaunchComplete() async {
    await _prefs?.setBool(_keyFirstLaunch, false);
  }

  bool get isOnboardingComplete => _prefs?.getBool(_keyOnboardingComplete) ?? false;

  Future<void> setOnboardingComplete() async {
    await _prefs?.setBool(_keyOnboardingComplete, true);
  }

  String get selectedLanguage => _prefs?.getString(_keyLanguage) ?? 'en';

  Future<void> setSelectedLanguage(String language) async {
    await _prefs?.setString(_keyLanguage, language);
  }

  // Station Progress
  static const String _keyStationProgress = 'station_progress';

  Map<int, String> getStationProgress() {
    final progressString = _prefs?.getString(_keyStationProgress) ?? '{}';
    final Map<String, dynamic> progressMap = json.decode(progressString);
    return progressMap.map((key, value) => MapEntry(int.parse(key), value.toString()));
  }

  Future<void> setStationStatus(int stationId, String status) async {
    final currentProgress = getStationProgress();
    currentProgress[stationId] = status;

    final progressMap = currentProgress.map((key, value) => MapEntry(key.toString(), value));
    await _prefs?.setString(_keyStationProgress, json.encode(progressMap));
  }

  // User Profile Data
  static const String _keyUserProfile = 'user_profile';

  Map<String, dynamic> getUserProfile() {
    final profileString = _prefs?.getString(_keyUserProfile) ?? '{}';
    return json.decode(profileString);
  }

  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    await _prefs?.setString(_keyUserProfile, json.encode(profile));
  }

  // Station Results (for consistency)
  static const String _keyStationResults = 'station_results';

  Map<int, Map<String, dynamic>> getStationResults() {
    final resultsString = _prefs?.getString(_keyStationResults) ?? '{}';
    final Map<String, dynamic> resultsMap = json.decode(resultsString);
    return resultsMap.map((key, value) => MapEntry(int.parse(key), Map<String, dynamic>.from(value)));
  }

  Future<void> saveStationResult(int stationId, Map<String, dynamic> result) async {
    final currentResults = getStationResults();
    currentResults[stationId] = result;

    final resultsMap = currentResults.map((key, value) => MapEntry(key.toString(), value));
    await _prefs?.setString(_keyStationResults, json.encode(resultsMap));
  }

  // Analytics Data
  static const String _keyAnalyticsData = 'analytics_data';

  Map<String, dynamic> getAnalyticsData() {
    final analyticsString = _prefs?.getString(_keyAnalyticsData) ?? '{}';
    return json.decode(analyticsString);
  }

  Future<void> saveAnalyticsData(Map<String, dynamic> data) async {
    await _prefs?.setString(_keyAnalyticsData, json.encode(data));
  }

  // Share tracking
  static const String _keyShareCount = 'share_count';
  static const String _keyLastShareDate = 'last_share_date';

  int get shareCount => _prefs?.getInt(_keyShareCount) ?? 0;

  Future<void> incrementShareCount() async {
    final currentCount = shareCount;
    await _prefs?.setInt(_keyShareCount, currentCount + 1);
    await _prefs?.setString(_keyLastShareDate, DateTime.now().toIso8601String());
  }

  DateTime? get lastShareDate {
    final dateString = _prefs?.getString(_keyLastShareDate);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  // Clear all data (for testing or reset)
  Future<void> clearAllData() async {
    await _prefs?.clear();
  }

  // Clear specific data
  Future<void> resetOnboarding() async {
    await _prefs?.remove(_keyOnboardingComplete);
    await _prefs?.remove(_keyUserProfile);
  }

  Future<void> resetStationProgress() async {
    await _prefs?.remove(_keyStationProgress);
    await _prefs?.remove(_keyStationResults);
  }
}
