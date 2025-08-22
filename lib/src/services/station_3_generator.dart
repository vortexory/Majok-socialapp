import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/data/baby_profile_pools.dart';
import 'package:futu/src/models/baby_profile_model.dart';
import 'package:futu/src/services/deterministic_generator.dart';
import 'package:futu/src/services/storage_service.dart';

class Station3Generator {
  static final Station3Generator _instance = Station3Generator._internal();
  factory Station3Generator() => _instance;
  Station3Generator._internal();

  static Station3Generator get instance => _instance;

  /// Generates baby profile based on user inputs
  BabyProfile generateBabyProfile({
    required AppLocalizations localizations,
    int? heartsCaught,
    int? timeSpent,
    Map<String, dynamic>? additionalInputs,
  }) {
    // Get user profile for consistency but reduce its impact
    final userProfile = StorageService.instance.getUserProfile();

    // Create seed with game performance having MUCH more impact
    final seedInputs = <String, dynamic>{
      // Make game performance highly influential
      'primary_hearts': heartsCaught ?? 10,
      'hearts_squared': (heartsCaught ?? 10) * (heartsCaught ?? 10),
      'hearts_multiplier': _getHeartsMultiplier(heartsCaught ?? 10),

      // Make time performance influential
      'primary_time': timeSpent ?? 5,
      'time_squared': (timeSpent ?? 5) * (timeSpent ?? 5),
      'time_multiplier': _getTimeMultiplier(timeSpent ?? 5),

      // Performance combinations for more variety
      'performance_ratio': (heartsCaught ?? 10) / (timeSpent ?? 5),
      'performance_score': (heartsCaught ?? 10) * 100 + (timeSpent ?? 5) * 10,
      'efficiency_score': ((heartsCaught ?? 10) / (timeSpent ?? 5) * 1000).round(),

      // Reduce impact of static user data - only use initials
      'user_initial': (userProfile['name']?.toString() ?? 'user')[0],
      'user_age_mod': (userProfile['age'] ?? 25) % 10, // Only last digit
      'station': 3,

      // Add game-specific variations for more diversity
      'game_combination': '${heartsCaught ?? 10}_${timeSpent ?? 5}_bottle_filling',
      'performance_hash': '${heartsCaught ?? 10}_${timeSpent ?? 5}'.hashCode,

      ...?additionalInputs,
    };

    final seed = DeterministicGenerator.instance.createSeed(seedInputs);
    print('Station 3 Generated seed: $seed for inputs: $seedInputs'); // Debug

    // Generate baby profile using game-performance-influenced deterministic selection
    final performanceBonus =
        _getHeartsMultiplier(heartsCaught ?? 10) +
        _getTimeMultiplier(timeSpent ?? 5) +
        _getEfficiencyBonus(heartsCaught ?? 10, timeSpent ?? 5);

    final name = DeterministicGenerator.instance.selectFromPool(pool: BabyProfilePool.names, seed: seed + performanceBonus, offset: 1);
    print('Station 3 Selected name: $name'); // Debug

    // Select 4 things baby loves with performance influence
    final selectedLovesFunctions = DeterministicGenerator.instance.selectMultipleFromPool(
      pool: BabyProfilePool.lovesList,
      count: 4,
      seed: seed + (performanceBonus * 2),
      offset: 2,
    );
    print('Station 3 Selected ${selectedLovesFunctions.length} loves'); // Debug

    // Select 4 things baby hates with performance influence
    final selectedHatesFunctions = DeterministicGenerator.instance.selectMultipleFromPool(
      pool: BabyProfilePool.hatesList,
      count: 4,
      seed: seed + (performanceBonus * 3),
      offset: 3,
    );
    print('Station 3 Selected ${selectedHatesFunctions.length} hates'); // Debug

    print('Station 3 Generated baby profile successfully with game performance influence'); // Debug

    return BabyProfile(
      name: name,
      imagePath: 'assets/images/baby_avatar.png', // Can be randomized later
      loves: selectedLovesFunctions, // Keep functions for dynamic localization
      hates: selectedHatesFunctions, // Keep functions for dynamic localization
    );
  }

  /// Get numeric multiplier based on hearts caught for more variation
  int _getHeartsMultiplier(int heartsCaught) {
    // Create significant variation based on performance
    if (heartsCaught <= 5) return 1000;
    if (heartsCaught <= 10) return 2000;
    if (heartsCaught <= 15) return 3000;
    if (heartsCaught <= 20) return 4000;
    return 5000; // Perfect or over-performance
  }

  /// Get numeric multiplier based on time spent for more variation
  int _getTimeMultiplier(int timeSpent) {
    // Faster completion gets different multipliers
    if (timeSpent <= 3) return 100; // Very fast
    if (timeSpent <= 5) return 200; // Fast
    if (timeSpent <= 7) return 300; // Normal
    if (timeSpent <= 10) return 400; // Slow
    return 500; // Very slow
  }

  /// Get efficiency bonus based on hearts vs time ratio
  int _getEfficiencyBonus(int heartsCaught, int timeSpent) {
    final efficiency = heartsCaught / timeSpent;
    if (efficiency >= 4.0) return 10000; // Extremely efficient
    if (efficiency >= 3.0) return 8000; // Very efficient
    if (efficiency >= 2.0) return 6000; // Efficient
    if (efficiency >= 1.0) return 4000; // Average
    return 2000; // Below average
  }

  /// Saves the generated result for consistency
  Future<void> saveResult(BabyProfile profile, AppLocalizations localizations) async {
    final resultData = {
      'name': profile.name,
      'imagePath': profile.imagePath,
      'loves': profile.loves.map((func) => func(localizations)).toList(),
      'hates': profile.hates.map((func) => func(localizations)).toList(),
      'generated_at': DateTime.now().toIso8601String(),
    };

    await StorageService.instance.saveStationResult(3, resultData);
    print('Station 3 saved result successfully'); // Debug
  }

  /// Retrieves a previously generated result
  BabyProfile? getSavedResult() {
    final results = StorageService.instance.getStationResults();
    final station3Result = results[3];

    if (station3Result != null) {
      print('Station 3 found saved result: $station3Result'); // Debug
      // Create simple string functions from saved data
      final lovesList = List<String>.from(station3Result['loves'] ?? []);
      final hatesList = List<String>.from(station3Result['hates'] ?? []);

      return BabyProfile(
        name: station3Result['name'] ?? 'Luna Celeste',
        imagePath: station3Result['imagePath'] ?? 'assets/images/baby_avatar.png',
        loves: lovesList
            .map(
              (love) =>
                  (AppLocalizations l) => love,
            )
            .toList(),
        hates: hatesList
            .map(
              (hate) =>
                  (AppLocalizations l) => hate,
            )
            .toList(),
      );
    }

    print('Station 3 no saved result found'); // Debug
    return null;
  }
}
