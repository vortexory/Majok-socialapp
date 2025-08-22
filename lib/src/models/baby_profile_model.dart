import 'package:futu/l10n/app_localizations.dart';

// This class holds the generated data for the Station 3 result.
class BabyProfile {
  final String name;
  final String imagePath;
  final List<String Function(AppLocalizations)> loves;
  final List<String Function(AppLocalizations)> hates;

  BabyProfile({
    required this.name,
    required this.imagePath,
    required this.loves,
    required this.hates,
  });

  // A factory to generate a placeholder profile.
  factory BabyProfile.generate() {
    return BabyProfile(
      name: "Luna Celeste",
      imagePath: 'assets/images/baby_avatar.png',
      loves: [
        (l) => l.babyLove1,
        (l) => l.babyLove2,
        (l) => l.babyLove3,
        (l) => l.babyLove4,
      ],
      hates: [
        (l) => l.babyHate1,
        (l) => l.babyHate2,
        (l) => l.babyHate3,
        (l) => l.babyHate4,
      ],
    );
  }
}