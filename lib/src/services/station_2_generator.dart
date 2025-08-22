import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/data/romance_story_pools.dart';
import 'package:futu/src/models/romance_story_model.dart';
import 'package:futu/src/services/deterministic_generator.dart';
import 'package:futu/src/services/storage_service.dart';

class Station2Generator {
  static final Station2Generator _instance = Station2Generator._internal();
  factory Station2Generator() => _instance;
  Station2Generator._internal();

  static Station2Generator get instance => _instance;

  /// Generates romance story based on user inputs
  RomanceStory generateRomanceStory({
    required AppLocalizations localizations,
    String? selectedZodiac,
    String? selectedAnimal,
    String? selectedRide,
    String? dreamDestination,
    Map<String, dynamic>? additionalInputs,
  }) {
    // Get user profile for consistency but reduce its impact
    final userProfile = StorageService.instance.getUserProfile();

    // Create seed with user choices having MUCH more impact
    final seedInputs = <String, dynamic>{
      // Make zodiac choice more influential by adding multiple variations
      'primary_zodiac': selectedZodiac ?? 'aries',
      'zodiac_hash': (selectedZodiac ?? 'aries').hashCode,
      'zodiac_length': (selectedZodiac ?? 'aries').length,
      'zodiac_multiplier': _getZodiacMultiplier(selectedZodiac),

      // Make animal choice highly influential
      'primary_animal': selectedAnimal ?? 'cat',
      'animal_hash': (selectedAnimal ?? 'cat').hashCode,
      'animal_multiplier': _getAnimalMultiplier(selectedAnimal),

      // Make ride choice highly influential
      'primary_ride': selectedRide ?? 'air_balloon',
      'ride_hash': (selectedRide ?? 'air_balloon').hashCode,
      'ride_multiplier': _getRideMultiplier(selectedRide),

      // Dream destination influence
      'destination': dreamDestination ?? 'paris',
      'destination_hash': (dreamDestination ?? 'paris').hashCode,
      'destination_length': (dreamDestination ?? 'paris').length,

      // Reduce impact of static user data - only use initials
      'user_initial': (userProfile['name']?.toString() ?? 'user')[0],
      'user_age_mod': (userProfile['age'] ?? 25) % 10, // Only last digit
      'station': 2,

      // Add choice-specific combinations for more diversity
      'choice_combination': '${selectedZodiac}_${selectedAnimal}_${selectedRide}_${dreamDestination ?? "default"}',
      'choices_combined_hash': '${selectedZodiac}_${selectedAnimal}_${selectedRide}'.hashCode,

      ...?additionalInputs,
    };

    final seed = DeterministicGenerator.instance.createSeed(seedInputs);
    print('Station 2 Generated seed: $seed for inputs: $seedInputs'); // Debug

    // Generate story components using choice-influenced deterministic selection
    final choiceBonus = _getZodiacMultiplier(selectedZodiac) + _getAnimalMultiplier(selectedAnimal) + _getRideMultiplier(selectedRide);

    final meetingStoryFunction = DeterministicGenerator.instance.selectFromPool(
      pool: RomanceStoryPool.meetingStories,
      seed: seed + choiceBonus,
      offset: 1,
    );

    final proposalStoryFunction = DeterministicGenerator.instance.selectFromPool(
      pool: RomanceStoryPool.proposalStories,
      seed: seed + (choiceBonus * 2),
      offset: 2,
    );

    final weddingStoryFunction = DeterministicGenerator.instance.selectFromPool(
      pool: RomanceStoryPool.weddingStories,
      seed: seed + (choiceBonus * 3),
      offset: 3,
    );

    // Convert functions to actual strings
    final howYouMet = meetingStoryFunction(localizations);
    final theProposal = proposalStoryFunction(localizations);
    final theWedding = weddingStoryFunction(localizations);

    print('Station 2 Generated story successfully with choice influence'); // Debug

    return RomanceStory(howYouMet: howYouMet, theProposal: theProposal, theWedding: theWedding);
  }

  /// Get numeric multiplier based on zodiac choice for more variation
  int _getZodiacMultiplier(String? zodiac) {
    switch (zodiac) {
      case 'aries':
        return 1000;
      case 'taurus':
        return 1500;
      case 'gemini':
        return 2000;
      case 'cancer':
        return 2500;
      case 'leo':
        return 3000;
      case 'virgo':
        return 3500;
      case 'libra':
        return 4000;
      case 'scorpio':
        return 4500;
      case 'sagittarius':
        return 5000;
      case 'capricorn':
        return 5500;
      case 'aquarius':
        return 6000;
      case 'pisces':
        return 6500;
      default:
        return 1000;
    }
  }

  /// Get numeric multiplier based on animal choice for more variation
  int _getAnimalMultiplier(String? animal) {
    switch (animal) {
      case 'cow':
        return 100;
      case 'cat':
        return 200;
      case 'dog':
        return 300;
      case 'globe':
        return 400;
      case 'xmark':
        return 500;
      case 'rabbit':
        return 600;
      default:
        return 200;
    }
  }

  /// Get numeric multiplier based on ride choice for more variation
  int _getRideMultiplier(String? ride) {
    switch (ride) {
      case 'air_balloon':
        return 10;
      case 'race_car':
        return 20;
      case 'motorcycle':
        return 30;
      case 'bicycle':
        return 40;
      case 'bus':
        return 50;
      case 'truck_van':
        return 60;
      default:
        return 10;
    }
  }

  /// Saves the generated result for consistency
  Future<void> saveResult(RomanceStory story) async {
    final resultData = {
      'howYouMet': story.howYouMet,
      'theProposal': story.theProposal,
      'theWedding': story.theWedding,
      'generated_at': DateTime.now().toIso8601String(),
    };

    await StorageService.instance.saveStationResult(2, resultData);
    print('Station 2 saved result successfully'); // Debug
  }

  /// Retrieves a previously generated result
  RomanceStory? getSavedResult(AppLocalizations localizations) {
    final results = StorageService.instance.getStationResults();
    final station2Result = results[2];

    if (station2Result != null) {
      print('Station 2 found saved result: $station2Result'); // Debug
      return RomanceStory(
        howYouMet: station2Result['howYouMet'] ?? localizations.storyMetParagraph,
        theProposal: station2Result['theProposal'] ?? localizations.storyProposalParagraph,
        theWedding: station2Result['theWedding'] ?? localizations.storyWeddingParagraph,
      );
    }

    print('Station 2 no saved result found'); // Debug
    return null;
  }
}
