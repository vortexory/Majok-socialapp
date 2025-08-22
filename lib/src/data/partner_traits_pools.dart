import 'package:futu/l10n/app_localizations.dart';

class PartnerTraitsPool {
  // Height pools (in cm)
  static const List<String> heights = [
    "165 cm", "168 cm", "170 cm", "172 cm", "175 cm", 
    "177 cm", "180 cm", "182 cm", "185 cm", "188 cm",
    "163 cm", "190 cm", "158 cm", "192 cm", "160 cm"
  ];

  // Weight pools (in kg)
  static const List<String> weights = [
    "60 kg", "65 kg", "70 kg", "72 kg", "75 kg",
    "78 kg", "80 kg", "82 kg", "85 kg", "68 kg",
    "63 kg", "77 kg", "73 kg", "88 kg", "58 kg"
  ];

  // Eye color pools
  static List<String Function(AppLocalizations)> eyeColors = [
    (l) => l.eyeColorBrown,
    (l) => l.eyeColorBlue,
    (l) => l.eyeColorGreen,
    (l) => l.eyeColorHazel,
    (l) => l.eyeColorGray,
    (l) => l.eyeColorAmber,
    (l) => l.eyeColorBlack,
    (l) => l.eyeColorDarkBrown,
    (l) => l.eyeColorLightBlue,
    (l) => l.eyeColorDeepGreen,
    (l) => l.eyeColorGolden,
    (l) => l.eyeColorViolet,
    (l) => l.eyeColorTurquoise,
    (l) => l.eyeColorEmerald,
    (l) => l.eyeColorChestnut,
  ];

  // Hobbies combinations
  static List<String Function(AppLocalizations)> hobbies = [
    (l) => l.hobbiesGamingArt,
    (l) => l.hobbiesReadingMusic,
    (l) => l.hobbiesCookingTravel,
    (l) => l.hobbiesFitnessPhotography,
    (l) => l.hobbiesWritingCoffee,
    (l) => l.hobbiesDancingMovies,
    (l) => l.hobbiesGardeningBooks,
    (l) => l.hobbiesPaintingHiking,
    (l) => l.hobbiesYogaMeditation,
    (l) => l.hobbiesSingingGuitar,
    (l) => l.hobbiesRunningSwimming,
    (l) => l.hobbiesBakingCrafts,
    (l) => l.hobbiesVolunteeringPets,
    (l) => l.hobbiesLanguagesTravel,
    (l) => l.hobbiesTechInnovation,
  ];

  // Funny quirks pools
  static List<String Function(AppLocalizations)> funnyQuirks = [
    (l) => l.quirkHatesKetchup,
    (l) => l.quirkKnowsPokemon,
    (l) => l.quirkSingsInCar,
    (l) => l.quirkCollectsRocks,
    (l) => l.quirkTalksToPlants,
    (l) => l.quirkDancesWhileCooking,
    (l) => l.quirkCountsSteps,
    (l) => l.quirkNamesDevices,
    (l) => l.quirkMemorizesLyrics,
    (l) => l.quirkOrganizesByColor,
    (l) => l.quirkMakesWeirdFaces,
    (l) => l.quirkHumsUnconsciously,
    (l) => l.quirkPerfectionist,
    (l) => l.quirkNightOwl,
    (l) => l.quirkLaughsAtOwnJokes,
  ];
}