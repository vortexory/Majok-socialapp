import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/models/station_model.dart';
import 'package:futu/src/providers/stations_provider.dart';
import 'package:futu/src/providers/user_profile_provider.dart';
import 'package:futu/src/providers/user_state_provider.dart';
import 'package:futu/src/screens/onboarding_screen.dart';
import 'package:futu/src/screens/station_1/station_1_card_selection_screen.dart';
import 'package:futu/src/screens/station_2/station_2_onboarding_screen.dart';
import 'package:futu/src/screens/station_3/station_3_challenge_screen.dart';
import 'package:futu/src/screens/station_4/station_4_preferences_screen.dart';
import 'package:futu/src/screens/station_5/station_5_puzzle_screen.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/theme/app_theme.dart';
import 'package:futu/src/widgets/banner_ad_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(stationsProvider);
    final userProfile = ref.watch(userProfileProvider);
    final userState = ref.watch(userStateProvider);
    final localizations = AppLocalizations.of(context)!;

    // Create dynamic stations based on user progress
    final dynamicStations = _buildDynamicStations(stations, userState.stationProgress, localizations);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.hubTitle, style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF6A65F0),
              child: Text(
                userProfile.initials,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          const SizedBox(height: 16),
          _buildWelcomeSection(context, userProfile, localizations),
          const SizedBox(height: 20),
          const BannerAdWidget(placement: 'dashboard_top', margin: EdgeInsets.only(bottom: 20)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dynamicStations.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              return _StationCard(station: dynamicStations[index]);
            },
          ),
          const SizedBox(height: 20),
          const BannerAdWidget(placement: 'dashboard_bottom', margin: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, userProfile, AppLocalizations localizations) {
    final firstName = userProfile.name.split(' ').first;
    final timeOfDay = _getTimeOfDay(localizations);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A65F0), Color(0xFF9C88FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.dashboardGreeting(timeOfDay, firstName),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.dashboardSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }

  List<Station> _buildDynamicStations(List<Station> baseStations, Map<int, String> progress, AppLocalizations localizations) {
    return baseStations.map((station) {
      StationStatus status;
      // Handle station 6 as a special case: it's always unlocked.
      if (station.id == 6) {
        status = StationStatus.unlocked;
      } else if (progress.containsKey(station.id)) {
        final stationProgress = progress[station.id]!;
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
        if (station.id == 1) {
          status = StationStatus.unlocked;
        } else {
          final previousStationCompleted = progress[station.id - 1] == 'completed';
          status = previousStationCompleted ? StationStatus.unlocked : StationStatus.locked;
        }
      }
      return Station(id: station.id, getTitle: station.getTitle, imagePath: station.imagePath, status: status);
    }).toList();
  }

  String _getTimeOfDay(AppLocalizations localizations) {
    final hour = DateTime.now().hour;
    if (hour < 12) return localizations.timeOfDayMorning;
    if (hour < 17) return localizations.timeOfDayAfternoon;
    return localizations.timeOfDayEvening;
  }
}

// MODIFIED: Converted to a ConsumerWidget to access ref for the restart action.
class _StationCard extends ConsumerWidget {
  final Station station;
  const _StationCard({required this.station});

  // --- Start of logic moved from ProfileScreen ---
  void _showRestartConfirmation(BuildContext context, AppLocalizations localizations, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.restartJourneyConfirmationTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'This will delete all your progress and take you back to the beginning. Are you sure?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                AudioService.instance.play(Sound.tap);
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              onPressed: () async {
                AudioService.instance.play(Sound.generalReveal);
                Navigator.of(context).pop();
                await _restartJourney(context, ref);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor, foregroundColor: Colors.white),
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _restartJourney(BuildContext context, WidgetRef ref) async {
    try {
      await AnalyticsService.instance.logUserChoice(choiceType: 'dashboard_action', choiceValue: 'restart_journey');
      await ref.read(userStateProvider.notifier).resetProgress();
      ref.read(userProfileProvider.notifier).clearProfile();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const OnboardingScreen()), (route) => false);
      }
    } catch (e) {
      print('Error restarting journey: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Something went wrong. Please try again.'), backgroundColor: Colors.red));
      }
    }
  }
  // --- End of logic moved from ProfileScreen ---

  String _getCardImagePath(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final languageSuffix = isArabic ? 'ar' : 'en';
    return 'assets/images/station_cards/station_${station.id}_$languageSuffix.png';
  }

  void _handleTap(BuildContext context, WidgetRef ref) async {
    final localizations = AppLocalizations.of(context)!;

    // Special handling for Station 6
    if (station.id == 6) {
      _showRestartConfirmation(context, localizations, ref);
      return;
    }

    if (station.status == StationStatus.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.stationLockedMessage),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    await AnalyticsService.instance.logStationStart(station.id, station.getTitle(localizations));
    Widget? destination;
    switch (station.id) {
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
        return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => destination!));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color borderColor;
    switch (station.status) {
      case StationStatus.completed:
        borderColor = Colors.green;
        break;
      case StationStatus.unlocked:
        borderColor = Colors.orange;
        break;
      case StationStatus.locked:
      default:
        borderColor = Colors.grey.shade300;
        break;
    }

    bool isLocked = station.status == StationStatus.locked;
    bool isCompleted = station.status == StationStatus.completed;

    return GestureDetector(
      onTap: () {
        AudioService.instance.play(Sound.transition);
        _handleTap(context, ref);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _getCardImagePath(context),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFFEF3E8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, size: 50, color: Colors.grey[700]),
                          const SizedBox(height: 8),
                          Text("Station ${station.id}", style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (isLocked)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: Icon(Icons.lock, color: Colors.white70, size: 40)),
                ),
              // The "Retry" icon is only shown for completed stations (1-5)
              if (isCompleted && station.id != 6)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        AudioService.instance.play(Sound.tap);
                        _handleTap(context, ref);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.refresh, size: 18, color: Colors.green),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
