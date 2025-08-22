import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:futu/src/services/storage_service.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  static AnalyticsService get instance => _instance;

  FirebaseAnalytics? _analytics;
  FirebaseAnalyticsObserver? _observer;

  FirebaseAnalytics get analytics => _analytics!;
  FirebaseAnalyticsObserver get observer => _observer!;

  Future<void> initialize() async {
    _analytics = FirebaseAnalytics.instance;
    _observer = FirebaseAnalyticsObserver(analytics: _analytics!);

    // Set default user properties
    await _setInitialUserProperties();
  }

  Future<void> _setInitialUserProperties() async {
    final language = StorageService.instance.selectedLanguage;
    final isReturningUser = !StorageService.instance.isFirstLaunch;

    await _analytics?.setUserProperty(name: 'language', value: language);
    await _analytics?.setUserProperty(name: 'user_type', value: isReturningUser ? 'returning' : 'new');
    await _analytics?.setUserProperty(name: 'app_version', value: '1.0.0');
  }

  // ===== APP LIFECYCLE EVENTS =====
  Future<void> logAppOpen() async {
    await _analytics?.logAppOpen();
  }

  Future<void> logFirstLaunch() async {
    await _analytics?.logEvent(name: 'first_launch', parameters: {'timestamp': DateTime.now().toIso8601String()});
  }

  Future<void> logReturningUser() async {
    final lastVisit = StorageService.instance.getAnalyticsData()['last_visit'];
    await _analytics?.logEvent(
      name: 'returning_user',
      parameters: {'last_visit': lastVisit ?? 'unknown', 'timestamp': DateTime.now().toIso8601String()},
    );

    // Update last visit
    await StorageService.instance.saveAnalyticsData({'last_visit': DateTime.now().toIso8601String()});
  }

  // ===== ONBOARDING EVENTS =====
  Future<void> logOnboardingStart() async {
    await _analytics?.logEvent(name: 'onboarding_start', parameters: {'timestamp': DateTime.now().toIso8601String()});
  }

  Future<void> logOnboardingComplete() async {
    await _analytics?.logEvent(name: 'onboarding_complete', parameters: {'timestamp': DateTime.now().toIso8601String()});
  }

  Future<void> logOnboardingStep(int step) async {
    await _analytics?.logEvent(
      name: 'onboarding_step',
      parameters: {'step': step, 'step_name': _getOnboardingStepName(step), 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  Future<void> logOnboardingAbandon(int step) async {
    await _analytics?.logEvent(
      name: 'onboarding_abandon',
      parameters: {'step': step, 'step_name': _getOnboardingStepName(step), 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  String _getOnboardingStepName(int step) {
    switch (step) {
      case 1:
        return 'name';
      case 2:
        return 'age';
      case 3:
        return 'height';
      case 4:
        return 'weight';
      case 5:
        return 'hobbies';
      case 6:
        return 'education';
      case 7:
        return 'gender';
      default:
        return 'unknown';
    }
  }

  // ===== STATION EVENTS =====
  Future<void> logStationStart(int stationId, String stationName) async {
    await _analytics?.logEvent(
      name: 'station_start',
      parameters: {'station_id': stationId, 'station_name': stationName, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  Future<void> logStationComplete(int stationId, String stationName) async {
    await _analytics?.logEvent(
      name: 'station_complete',
      parameters: {'station_id': stationId, 'station_name': stationName, 'timestamp': DateTime.now().toIso8601String()},
    );

    // Track progression
    await _updateUserProgression(stationId);
  }

  Future<void> logStationRetry(int stationId, String stationName) async {
    await _analytics?.logEvent(
      name: 'station_retry',
      parameters: {'station_id': stationId, 'station_name': stationName, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  Future<void> logStationAbandon(int stationId, String stationName, int timeSpent) async {
    await _analytics?.logEvent(
      name: 'station_abandon',
      parameters: {
        'station_id': stationId,
        'station_name': stationName,
        'time_spent_seconds': timeSpent,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ===== USER ENGAGEMENT EVENTS =====
  Future<void> logUserChoice({
    required String choiceType,
    required String choiceValue,
    int? stationId,
    Map<String, dynamic>? additionalData,
  }) async {
    await _analytics?.logEvent(
      name: 'user_choice',
      parameters: {
        'choice_type': choiceType,
        'choice_value': choiceValue,
        if (stationId != null) 'station_id': stationId,
        'timestamp': DateTime.now().toIso8601String(),
        ...?additionalData,
      },
    );
  }

  Future<void> logGameInteraction({
    required String gameType,
    required String action,
    int? score,
    int? timeSpent,
    Map<String, dynamic>? additionalData,
  }) async {
    await _analytics?.logEvent(
      name: 'game_interaction',
      parameters: {
        'game_type': gameType,
        'action': action,
        if (score != null) 'score': score,
        if (timeSpent != null) 'time_spent_seconds': timeSpent,
        'timestamp': DateTime.now().toIso8601String(),
        ...?additionalData,
      },
    );
  }

  // ===== SHARING EVENTS =====
  Future<void> logResultShare(int stationId, String shareMethod) async {
    await _analytics?.logEvent(
      name: 'result_share',
      parameters: {'station_id': stationId, 'share_method': shareMethod, 'timestamp': DateTime.now().toIso8601String()},
    );

    // Update user properties
    final shareCount = StorageService.instance.shareCount;
    await _analytics?.setUserProperty(name: 'total_shares', value: shareCount.toString());
    await _analytics?.setUserProperty(name: 'has_shared_result', value: 'true');
  }

  // FIXED: Changed parameter type from bool to String
  Future<void> logShareAttempt(int stationId, String shareMethod, String success) async {
    await _analytics?.logEvent(
      name: 'share_attempt',
      parameters: {
        'station_id': stationId,
        'share_method': shareMethod,
        'success': success, // Now accepts string instead of bool
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ===== LANGUAGE EVENTS =====
  Future<void> logLanguageChange(String fromLanguage, String toLanguage) async {
    await _analytics?.logEvent(
      name: 'language_change',
      parameters: {'from_language': fromLanguage, 'to_language': toLanguage, 'timestamp': DateTime.now().toIso8601String()},
    );

    await _analytics?.setUserProperty(name: 'language', value: toLanguage);
  }

  // ===== AD EVENTS =====
  Future<void> logAdImpression(String adType, String placement) async {
    await _analytics?.logEvent(
      name: 'ad_impression',
      parameters: {'ad_type': adType, 'placement': placement, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  Future<void> logAdClick(String adType, String placement) async {
    await _analytics?.logEvent(
      name: 'ad_click',
      parameters: {'ad_type': adType, 'placement': placement, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  Future<void> logAdRevenue(double revenue, String currency, String adType) async {
    await _analytics?.logEvent(
      name: 'ad_revenue',
      parameters: {'revenue': revenue, 'currency': currency, 'ad_type': adType, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  // ===== ERROR AND PERFORMANCE EVENTS =====
  Future<void> logError(String errorType, String errorMessage, String? stackTrace) async {
    await _analytics?.logEvent(
      name: 'app_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage.length > 100 ? errorMessage.substring(0, 100) : errorMessage,
        'has_stack_trace': stackTrace != null ? 'true' : 'false', // Convert bool to string
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logPerformance({required String action, required int durationMs, Map<String, dynamic>? additionalData}) async {
    await _analytics?.logEvent(
      name: 'performance',
      parameters: {'action': action, 'duration_ms': durationMs, 'timestamp': DateTime.now().toIso8601String(), ...?additionalData},
    );
  }

  // ===== USER PROPERTIES MANAGEMENT =====
  Future<void> _updateUserProgression(int completedStationId) async {
    final stationProgress = StorageService.instance.getStationProgress();
    final completedStations = stationProgress.values.where((status) => status == 'completed').length;

    await _analytics?.setUserProperty(name: 'completed_stations', value: completedStations.toString());
    await _analytics?.setUserProperty(name: 'progression_level', value: _getProgressionLevel(completedStations));
    await _analytics?.setUserProperty(name: 'latest_station', value: completedStationId.toString());
  }

  String _getProgressionLevel(int completedStations) {
    switch (completedStations) {
      case 0:
        return 'beginner';
      case 1:
        return 'novice';
      case 2:
        return 'explorer';
      case 3:
        return 'adventurer';
      case 4:
        return 'expert';
      case 5:
        return 'master';
      default:
        return 'unknown';
    }
  }

  // ===== CUSTOM EVENTS FOR BUSINESS INSIGHTS =====
  Future<void> logUserRetention(int daysSinceFirstLaunch) async {
    await _analytics?.logEvent(
      name: 'user_retention',
      parameters: {
        'days_since_first_launch': daysSinceFirstLaunch,
        'retention_bucket': _getRetentionBucket(daysSinceFirstLaunch),
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  String _getRetentionBucket(int days) {
    if (days <= 1) return 'day_1';
    if (days <= 7) return 'week_1';
    if (days <= 30) return 'month_1';
    return 'long_term';
  }

  Future<void> logFeatureUsage(String featureName, Map<String, dynamic>? parameters) async {
    await _analytics?.logEvent(
      name: 'feature_usage',
      parameters: {'feature_name': featureName, 'timestamp': DateTime.now().toIso8601String(), ...?parameters},
    );
  }

  // ===== CONVERSION EVENTS =====
  Future<void> logConversion(String conversionType, {Map<String, dynamic>? additionalData}) async {
    await _analytics?.logEvent(
      name: 'conversion',
      parameters: {'conversion_type': conversionType, 'timestamp': DateTime.now().toIso8601String(), ...?additionalData},
    );
  }
}
