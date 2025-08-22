import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/data/partner_traits_pools.dart';
import 'package:futu/src/models/partner_traits_model.dart';
import 'package:futu/src/services/deterministic_generator.dart';
import 'package:futu/src/services/storage_service.dart';

class Station1Generator {
  static final Station1Generator _instance = Station1Generator._internal();
  factory Station1Generator() => _instance;
  Station1Generator._internal();

  static Station1Generator get instance => _instance;

  /// Generates partner traits based on user inputs
  PartnerTraits generatePartnerTraits({
    required AppLocalizations localizations,
    String? selectedDestiny,
    Map<String, dynamic>? additionalInputs,
  }) {
    try {
      // Get user profile for consistency but reduce its impact
      final userProfile = StorageService.instance.getUserProfile();

      // Create seed with user choices having much more impact
      final seedInputs = <String, dynamic>{
        // Make destiny choice MUCH more influential by adding multiple variations
        'primary_destiny': selectedDestiny ?? 'sage',
        'destiny_hash': (selectedDestiny ?? 'sage').hashCode,
        'destiny_length': (selectedDestiny ?? 'sage').length,
        'destiny_multiplier': _getDestinyMultiplier(selectedDestiny),

        // Add the game performance as major factors
        'hearts_caught': additionalInputs?['hearts_caught'] ?? 10,
        'time_spent': additionalInputs?['time_spent'] ?? 5,
        'performance_score': (additionalInputs?['hearts_caught'] ?? 10) * (additionalInputs?['time_spent'] ?? 5),
        'catch_rate': ((additionalInputs?['hearts_caught'] ?? 10) / 10 * 100).round(),

        // Reduce impact of static user data - only use initials
        'user_initial': (userProfile['name']?.toString() ?? 'user')[0],
        'user_age_mod': (userProfile['age'] ?? 25) % 10, // Only last digit
        'station': 1,

        // Add choice-specific variations for more diversity
        'choice_combination': '${selectedDestiny}_${additionalInputs?['hearts_caught']}_${additionalInputs?['time_spent']}',
      };

      final seed = DeterministicGenerator.instance.createSeed(seedInputs);
      print('Generated seed: $seed for inputs: $seedInputs'); // Debug

      // Generate traits using choice-influenced deterministic selection
      final destinyBonus = _getDestinyMultiplier(selectedDestiny);

      final height = DeterministicGenerator.instance.selectFromPool(pool: PartnerTraitsPool.heights, seed: seed + destinyBonus, offset: 1);
      print('Selected height: $height'); // Debug

      final weight = DeterministicGenerator.instance.selectFromPool(
        pool: PartnerTraitsPool.weights,
        seed: seed + (destinyBonus * 2),
        offset: 2,
      );
      print('Selected weight: $weight'); // Debug

      final eyeColorFunction = DeterministicGenerator.instance.selectFromPool(
        pool: PartnerTraitsPool.eyeColors,
        seed: seed + (destinyBonus * 3),
        offset: 3,
      );
      print('Selected eye color function'); // Debug

      final hobbiesFunction = DeterministicGenerator.instance.selectFromPool(
        pool: PartnerTraitsPool.hobbies,
        seed: seed + (destinyBonus * 4),
        offset: 4,
      );
      print('Selected hobbies function'); // Debug

      // Select 3 funny quirks with choice influence
      final selectedQuirkFunctions = DeterministicGenerator.instance.selectMultipleFromPool(
        pool: PartnerTraitsPool.funnyQuirks,
        count: 3,
        seed: seed + (destinyBonus * 5),
        offset: 5,
      );
      print('Selected ${selectedQuirkFunctions.length} quirk functions'); // Debug

      // Convert functions to actual strings
      final eyeColor = eyeColorFunction(localizations);
      final hobbies = hobbiesFunction(localizations);
      final funnyQuirks = selectedQuirkFunctions.map((func) => func(localizations)).toList();

      print('Converted to strings - Eye color: $eyeColor, Hobbies: $hobbies'); // Debug

      final result = PartnerTraits(height: height, weight: weight, eyeColor: eyeColor, hobbies: hobbies, funnyQuirks: funnyQuirks);

      print('Successfully generated partner traits with choice influence'); // Debug
      return result;
    } catch (e, stackTrace) {
      print('Error generating partner traits: $e');
      print('Stack trace: $stackTrace');

      // Return fallback data if generation fails
      return PartnerTraits(
        height: "175 cm",
        weight: "70 kg",
        eyeColor: "Brown",
        hobbies: "Reading & Music",
        funnyQuirks: ["Loves coffee in the morning", "Always loses keys", "Sings in the shower"],
      );
    }
  }

  /// Get numeric multiplier based on destiny choice for more variation
  int _getDestinyMultiplier(String? destiny) {
    switch (destiny) {
      case 'sage':
        return 1000; // Large multiplier for significant impact
      case 'voyager':
        return 2000;
      case 'guardian':
        return 3000;
      default:
        return 1000;
    }
  }

  /// Saves the generated result for consistency
  Future<void> saveResult(PartnerTraits traits) async {
    try {
      final resultData = {
        'height': traits.height,
        'weight': traits.weight,
        'eyeColor': traits.eyeColor,
        'hobbies': traits.hobbies,
        'funnyQuirks': traits.funnyQuirks,
        'generated_at': DateTime.now().toIso8601String(),
      };

      await StorageService.instance.saveStationResult(1, resultData);
      print('Saved station 1 result successfully'); // Debug
    } catch (e) {
      print('Error saving station 1 result: $e');
    }
  }

  /// Retrieves a previously generated result
  PartnerTraits? getSavedResult() {
    try {
      final results = StorageService.instance.getStationResults();
      final station1Result = results[1];

      if (station1Result != null) {
        print('Found saved result: $station1Result'); // Debug
        return PartnerTraits(
          height: station1Result['height'] ?? '175 cm',
          weight: station1Result['weight'] ?? '70 kg',
          eyeColor: station1Result['eyeColor'] ?? 'Brown',
          hobbies: station1Result['hobbies'] ?? 'Reading & Music',
          funnyQuirks: List<String>.from(station1Result['funnyQuirks'] ?? []),
        );
      }

      print('No saved result found'); // Debug
      return null;
    } catch (e) {
      print('Error retrieving saved result: $e');
      return null;
    }
  }
}
