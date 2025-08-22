import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/data/chat_message_pools.dart';
import 'package:futu/src/services/deterministic_generator.dart';
import 'package:futu/src/services/storage_service.dart';

class Station5Generator {
  static final Station5Generator _instance = Station5Generator._internal();
  factory Station5Generator() => _instance;
  Station5Generator._internal();

  static Station5Generator get instance => _instance;

  /// Generates final soulmate reveal based on all previous stations
  Map<String, dynamic> generateFinalReveal({
    required AppLocalizations localizations,
    int? constellationTime,
    bool? puzzleCompleted,
    Map<String, dynamic>? additionalInputs,
  }) {
    // Get user profile and all previous results for comprehensive seed
    final userProfile = StorageService.instance.getUserProfile();
    final allResults = StorageService.instance.getStationResults();

    // Create comprehensive seed from all user data
    final seedInputs = <String, dynamic>{
      'user_name': userProfile['name'] ?? 'user',
      'user_age': userProfile['age'] ?? 25,
      'user_gender': userProfile['gender']?.toString() ?? 'not_specified',
      'constellation_time': constellationTime ?? 60,
      'puzzle_completed': puzzleCompleted ?? true,
      'station_1_completed': allResults.containsKey(1),
      'station_2_completed': allResults.containsKey(2),
      'station_3_completed': allResults.containsKey(3),
      'station_4_completed': allResults.containsKey(4),
      'station': 5,
      ...?additionalInputs,
    };

    final seed = DeterministicGenerator.instance.createSeed(seedInputs);

    // Generate final match percentage (higher range for final reveal)
    final matchPercentage = DeterministicGenerator.instance.generateMatchPercentage(seed: seed, minPercentage: 85, maxPercentage: 99);

    // ===== MODIFIED: Get Partner Name from Station 4 for Consistency =====
    final station4Result = allResults[4];
    // Use the name from Station 4, with a fallback just in case.
    final partnerName = station4Result?['partner_name'] ?? 'Ariel';
    // ===================================================================

    // Generate final loves and hates (different from baby ones)
    final finalLoves = [localizations.finalLovesCoffee, localizations.finalLovesReading, localizations.finalLovesExploring];

    final finalHates = [localizations.finalHatesFootball, localizations.finalHatesMornings, localizations.finalHatesNoises];

    // Dynamic Avatar Selection Logic (from previous step)
    final userGender = userProfile['gender']?.toString().toLowerCase();
    final List<String> avatarPool;
    if (userGender == 'female') {
      avatarPool = ChatMessagePool.maleAvatars;
    } else {
      avatarPool = ChatMessagePool.femaleAvatars;
    }
    final avatarPath = DeterministicGenerator.instance.selectFromPool(pool: avatarPool, seed: seed, offset: 101);

    return {
      'partner_name': partnerName, // Use the consistent name
      'match_percentage': matchPercentage,
      'loves': finalLoves,
      'hates': finalHates,
      'avatar_path': avatarPath,
    };
  }

  /// Saves the generated result for consistency
  Future<void> saveResult(Map<String, dynamic> finalResult) async {
    final resultData = {...finalResult, 'generated_at': DateTime.now().toIso8601String()};

    await StorageService.instance.saveStationResult(5, resultData);
  }

  /// Retrieves a previously generated result
  Map<String, dynamic>? getSavedResult() {
    final results = StorageService.instance.getStationResults();
    return results[5];
  }
}
