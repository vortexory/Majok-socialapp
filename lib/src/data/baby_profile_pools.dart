import 'package:futu/l10n/app_localizations.dart';

class BabyProfilePool {
  // Baby names
  static const List<String> names = [
    "Luna Celeste", "Aria Rose", "Zara Moon", "Maya Star", 
    "Nova Grace", "Iris Dawn", "Sage River", "Eden Sky",
    "Aurora Belle", "Luna Sol", "Mila Joy", "Zoe Light",
    "Ava Dream", "Ella Hope", "Naia Ocean", "Kai Wonder"
  ];

  // What baby loves
  static List<String Function(AppLocalizations)> lovesList = [
    (l) => l.babyLovesMusic,
    (l) => l.babyLovesColors,
    (l) => l.babyLovesAnimals,
    (l) => l.babyLovesBooks,
    (l) => l.babyLovesNature,
    (l) => l.babyLovesDancing,
    (l) => l.babyLovesWater,
    (l) => l.babyLovesCuddles,
    (l) => l.babyLovesStars,
    (l) => l.babyLovesLaughter,
    (l) => l.babyLovesArt,
    (l) => l.babyLovesFlowers,
    (l) => l.babyLovesSinging,
    (l) => l.babyLovesAdventure,
    (l) => l.babyLovesSweets,
  ];

  // What baby hates
  static List<String Function(AppLocalizations)> hatesList = [
    (l) => l.babyHatesLoudNoises,
    (l) => l.babyHatesDarkness,
    (l) => l.babyHatesBroccoli,
    (l) => l.babyHatesWaiting,
    (l) => l.babyHatesCrowds,
    (l) => l.babyHatesBedtime,
    (l) => l.babyHatesRain,
    (l) => l.babyHatesSpicy,
    (l) => l.babyHatesMess,
    (l) => l.babyHatesGoodbye,
    (l) => l.babyHatesCold,
    (l) => l.babyHatesRush,
    (l) => l.babyHatesAngry,
    (l) => l.babyHatesBoring,
    (l) => l.babyHatesEmpty,
  ];
}