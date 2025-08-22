import 'package:futu/l10n/app_localizations.dart';

// This enum represents the possible states of a station.
enum StationStatus { locked, unlocked, completed }

// This class represents a single station on the dashboard.
class Station {
  final int id;
  final String Function(AppLocalizations) getTitle; // For localization
  final String imagePath;
  final StationStatus status;

  Station({
    required this.id,
    required this.getTitle,
    required this.imagePath,
    required this.status,
  });
}