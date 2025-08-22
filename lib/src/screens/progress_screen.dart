import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/models/station_model.dart';
import 'package:futu/src/providers/stations_provider.dart';
import 'package:futu/src/providers/user_state_provider.dart';
import 'package:futu/src/screens/station_1/station_1_card_selection_screen.dart';
import 'package:futu/src/screens/station_2/station_2_onboarding_screen.dart';
import 'package:futu/src/screens/station_3/station_3_challenge_screen.dart';
import 'package:futu/src/screens/station_4/station_4_preferences_screen.dart';
import 'package:futu/src/screens/station_5/station_5_puzzle_screen.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  // Helper to map station ID to its chapter title key
  String Function(AppLocalizations) getChapterTitle(int stationId) {
    switch (stationId) {
      case 1:
        return (l) => l.chapter1Title;
      case 2:
        return (l) => l.chapter2Title;
      case 3:
        return (l) => l.chapter3Title;
      case 4:
        return (l) => l.chapter4Title;
      case 5:
        return (l) => l.chapter5Title;
      default:
        return (l) => "";
    }
  }

  // Helper to map station ID to its icon
  String getChapterIcon(int stationId) {
    switch (stationId) {
      case 1:
        return 'assets/images/icon_magnifying_glass.png';
      case 2:
        return 'assets/images/icon_book.png';
      case 3:
        return 'assets/images/icon_baby.png';
      case 4:
        return 'assets/images/icon_chat_bubble.png';
      case 5:
        return 'assets/images/icon_heart_final.png';
      default:
        return "";
    }
  }

  // Helper to get summary based on completion status
  String getChapterSummary(int stationId, StationStatus status, AppLocalizations localizations) {
    if (status == StationStatus.locked) {
      return localizations.chapterLockedSubtitle;
    } else if (status == StationStatus.completed) {
      switch (stationId) {
        case 1:
          return localizations.chapter1CompletedSummary;
        case 2:
          return localizations.chapter2CompletedSummary;
        case 3:
          return localizations.chapter3CompletedSummary;
        case 4:
          return localizations.chapter4CompletedSummary;
        case 5:
          return localizations.chapter5CompletedSummary;
        default:
          return localizations.chapterCompletedDefault;
      }
    } else {
      // Unlocked but not completed
      switch (stationId) {
        case 1:
          return localizations.chapter1UnlockedSummary;
        case 2:
          return localizations.chapter2UnlockedSummary;
        case 3:
          return localizations.chapter3UnlockedSummary;
        case 4:
          return localizations.chapter4UnlockedSummary;
        case 5:
          return localizations.chapter5UnlockedSummary;
        default:
          return localizations.chapterUnlockedDefault;
      }
    }
  }

  // Navigation handler
  void _navigateToStation(BuildContext context, int stationId) async {
    // Track station start
    final localizations = AppLocalizations.of(context)!;
    await AnalyticsService.instance.logStationStart(stationId, 'Station $stationId');

    Widget? destination;
    switch (stationId) {
      case 1:
        destination = const Station1CardSelectionScreen();
        break;
      case 2:
        destination = const Station2OnboardingScreen();
        break;
      case 3:
        destination = const Station3ChallengeScreen();
        break;
      case 4:
        destination = const Station4PreferencesScreen();
        break;
      case 5:
        destination = const Station5PuzzleScreen();
        break;
      default:
        print("No navigation for Station $stationId");
        return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => destination!));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(stationsProvider);
    final userState = ref.watch(userStateProvider);
    final localizations = AppLocalizations.of(context)!;

    // Create dynamic stations based on user progress
    final dynamicStations = stations.map((station) {
      StationStatus status;

      // Determine status based on progress
      if (userState.stationProgress.containsKey(station.id)) {
        final stationProgress = userState.stationProgress[station.id]!;
        switch (stationProgress) {
          case 'completed':
            status = StationStatus.completed;
            break;
          case 'unlocked':
            status = StationStatus.unlocked;
            break;
          default:
            status = StationStatus.locked;
        }
      } else {
        // Default logic: Station 1 is always unlocked, others depend on previous completion
        if (station.id == 1) {
          status = StationStatus.unlocked;
        } else {
          final previousStationCompleted = userState.stationProgress[station.id - 1] == 'completed';
          status = previousStationCompleted ? StationStatus.unlocked : StationStatus.locked;
        }
      }

      return Station(id: station.id, getTitle: station.getTitle, imagePath: station.imagePath, status: status);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.progressScreenTitle, style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade50,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dynamicStations.length,
        itemBuilder: (context, index) {
          final station = dynamicStations[index];
          final chapterTitle = getChapterTitle(station.id)(localizations);
          final chapterIcon = getChapterIcon(station.id);
          final chapterSummary = getChapterSummary(station.id, station.status, localizations);

          final nextStationTitle = (index + 1 < dynamicStations.length)
              ? getChapterTitle(dynamicStations[index + 1].id)(localizations)
              : "";

          bool isNext =
              station.status == StationStatus.completed &&
              (index + 1 < dynamicStations.length) &&
              dynamicStations[index + 1].status == StationStatus.unlocked;

          return Column(
            children: [
              _StoryChapterCard(
                status: station.status,
                title: chapterTitle,
                iconPath: chapterIcon,
                summary: chapterSummary,
                onTap: station.status != StationStatus.locked
                    ? () {
                        AudioService.instance.play(Sound.transition);
                        _navigateToStation(context, station.id);
                      }
                    : null,
              ),
              if (isNext)
                _NextChapterCard(
                  title: localizations.chapterNextTitle(nextStationTitle),
                  onTap: () {
                    AudioService.instance.play(Sound.transition);
                    _navigateToStation(context, dynamicStations[index + 1].id);
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

// A reusable widget for displaying a chapter/memory card
class _StoryChapterCard extends StatelessWidget {
  final StationStatus status;
  final String title;
  final String iconPath;
  final String summary;
  final VoidCallback? onTap;

  const _StoryChapterCard({required this.status, required this.title, required this.iconPath, required this.summary, this.onTap});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final bool isLocked = status == StationStatus.locked;
    final Color themeColor = isLocked ? Colors.grey.shade400 : const Color(0xFF6A65F0);

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isLocked ? 0.6 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: themeColor.withOpacity(0.1), child: Image.asset(iconPath, height: 24)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLocked ? localizations.chapterLockedTitle : title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(summary, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              if (status == StationStatus.completed) const Icon(Icons.check_circle, color: Colors.green),
              if (status == StationStatus.unlocked && onTap != null) Icon(Icons.arrow_forward_ios, color: themeColor, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// A special card to prompt the user to the next station
class _NextChapterCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _NextChapterCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6A65F0);

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E7FD), // Light purple
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor),
      ),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, color: primaryColor)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              AppLocalizations.of(context)!.chapterNextButton,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
