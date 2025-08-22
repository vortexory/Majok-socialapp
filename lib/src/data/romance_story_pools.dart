import 'package:futu/l10n/app_localizations.dart';

class RomanceStoryPool {
  // How you met story fragments
  static List<String Function(AppLocalizations)> meetingStories = [
    (l) => l.storyMetCoffeeShop,
    (l) => l.storyMetBookstore,
    (l) => l.storyMetPark,
    (l) => l.storyMetLibrary,
    (l) => l.storyMetGym,
    (l) => l.storyMetAirport,
    (l) => l.storyMetConcert,
    (l) => l.storyMetBeach,
    (l) => l.storyMetMuseum,
    (l) => l.storyMetSupermarket,
    (l) => l.storyMetRain,
    (l) => l.storyMetElevator,
    (l) => l.storyMetDogPark,
    (l) => l.storyMetWorkshop,
    (l) => l.storyMetVolunteering,
  ];

  // Proposal story fragments
  static List<String Function(AppLocalizations)> proposalStories = [
    (l) => l.storyProposalSunset,
    (l) => l.storyProposalMountain,
    (l) => l.storyProposalHome,
    (l) => l.storyProposalRestaurant,
    (l) => l.storyProposalBeach,
    (l) => l.storyProposalGarden,
    (l) => l.storyProposalRooftop,
    (l) => l.storyProposalPicnic,
    (l) => l.storyProposalWalk,
    (l) => l.storyProposalStars,
    (l) => l.storyProposalRain,
    (l) => l.storyProposalCafe,
    (l) => l.storyProposalPark,
    (l) => l.storyProposalTrip,
    (l) => l.storyProposalSurprise,
  ];

  // Wedding story fragments
  static List<String Function(AppLocalizations)> weddingStories = [
    (l) => l.storyWeddingGarden,
    (l) => l.storyWeddingBeach,
    (l) => l.storyWeddingCastle,
    (l) => l.storyWeddingIntimate,
    (l) => l.storyWeddingVineyard,
    (l) => l.storyWeddingMountain,
    (l) => l.storyWeddingCity,
    (l) => l.storyWeddingRustic,
    (l) => l.storyWeddingTropical,
    (l) => l.storyWeddingWinter,
    (l) => l.storyWeddingModern,
    (l) => l.storyWeddingClassic,
    (l) => l.storyWeddingBoho,
    (l) => l.storyWeddingDestination,
    (l) => l.storyWeddingBackyard,
  ];
}