import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/models/baby_profile_model.dart';
import 'package:futu/src/providers/user_state_provider.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/services/station_3_generator.dart';
import 'package:futu/src/services/share_service.dart';
import 'package:futu/src/theme/app_theme.dart';

class Station3ResultScreen extends ConsumerStatefulWidget {
  final int heartsCaught;
  final int timeSpent;

  const Station3ResultScreen({Key? key, required this.heartsCaught, required this.timeSpent}) : super(key: key);

  @override
  ConsumerState<Station3ResultScreen> createState() => _Station3ResultScreenState();
}

class _Station3ResultScreenState extends ConsumerState<Station3ResultScreen> {
  BabyProfile? _babyProfile;
  bool _isLoading = true;
  String? _errorMessage;

  // Key for capturing the shareable content
  final GlobalKey _shareableKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateResult();
    });
  }

  Future<void> _generateResult() async {
    try {
      print('Generating Station 3 result...'); // Debug

      final localizations = AppLocalizations.of(context)!;

      // Always generate a new result based on current game performance
      // This ensures different performance levels produce different results
      print('Generating new baby profile for performance: ${widget.heartsCaught} hearts in ${widget.timeSpent}s'); // Debug

      // Generate new baby profile based on user input
      final babyProfile = Station3Generator.instance.generateBabyProfile(
        localizations: localizations,
        heartsCaught: widget.heartsCaught,
        timeSpent: widget.timeSpent,
        additionalInputs: {'generation_time': DateTime.now().toIso8601String()},
      );

      print('Generated baby profile successfully'); // Debug

      // Save the result for consistency (will overwrite previous if exists)
      await Station3Generator.instance.saveResult(babyProfile, localizations);
      print('Saved result successfully'); // Debug

      setState(() {
        _babyProfile = babyProfile;
        _isLoading = false;
      });

      // Mark station as completed and unlock next station
      await ref.read(userStateProvider.notifier).updateStationStatus(3, 'completed');
      await ref.read(userStateProvider.notifier).updateStationStatus(4, 'unlocked');
      print('Updated station status'); // Debug

      // Track completion
      await AnalyticsService.instance.logStationComplete(3, 'Baby Profile');
      print('Logged analytics'); // Debug

      // Play reveal sound
      AudioService.instance.play(Sound.generalReveal);
    } catch (e, stackTrace) {
      print('Error in Station 3 _generateResult: $e');
      print('Stack trace: $stackTrace');

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _retryGeneration() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _babyProfile = null;
    });

    await _generateResult();
  }

  Future<void> _shareResult() async {
    if (_babyProfile == null) return;

    try {
      await AnalyticsService.instance.logShareAttempt(3, 'image', 'true');

      final localizations = AppLocalizations.of(context)!;

      // Create text version for fallback
      final shareText =
          "${localizations.station3ResultTitle} 👶\n\n"
          "Meet ${_babyProfile!.name}! 💕\n\n"
          "${localizations.babyLoves}:\n"
          "${_babyProfile!.loves.take(3).map((f) => '• ${f(localizations)}').join('\n')}\n\n"
          "${localizations.babyHates}:\n"
          "${_babyProfile!.hates.take(3).map((f) => '• ${f(localizations)}').join('\n')}\n\n"
          "#FutuApp #BabyReveal #FutureFamily";

      // Try to share as image first
      final success = await ShareService.instance.shareWidgetAsImage(
        repaintBoundaryKey: _shareableKey,
        filename: 'futu_baby_reveal_${DateTime.now().millisecondsSinceEpoch}',
        shareText: shareText,
        stationId: 3,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? (localizations.shareSuccessMessage ?? 'Shared successfully! 💕')
                  : (localizations.shareErrorMessage ?? 'Failed to share. Please try again.'),
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error sharing Station 3 result: $e');

      await AnalyticsService.instance.logShareAttempt(3, 'image', 'false');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to share. Please try again.'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF6A65F0);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFDAE19B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
          centerTitle: true,
          title: Text(
            localizations.station3ResultTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black87),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: primaryColor),
              const SizedBox(height: 16),
              Text(
                localizations.generatingBabyMessage ?? 'Generating your baby profile...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null || _babyProfile == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFDAE19B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
          centerTitle: true,
          title: Text(
            localizations.station3ResultTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black87),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Oops! Something went wrong',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We couldn\'t generate your baby profile. Please try again.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _retryGeneration,
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                      child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(foregroundColor: primaryColor, backgroundColor: Colors.white.withOpacity(0.8)),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ORIGINAL DESIGN - Keep exactly as it was but with real data
    return Scaffold(
      backgroundColor: const Color(0xFFDAE19B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Text(localizations.station3ResultTitle, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black87)),
        actions: [
          IconButton(
            onPressed: () {
              AudioService.instance.play(Sound.tap);
            },
            icon: const Icon(Icons.favorite_border, color: Colors.black87),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Wrap the main content in RepaintBoundary for sharing
          RepaintBoundary(
            key: _shareableKey,
            child: Container(
              color: const Color(0xFFDAE19B), // Ensure background color is captured
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 180),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Baby Avatar
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.yellow.shade200,
                      child: CircleAvatar(radius: 95, backgroundImage: AssetImage(_babyProfile!.imagePath)),
                    ),
                    const SizedBox(height: 40),
                    // Floating white info card with margins
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: Column(
                        children: [
                          Text(_babyProfile!.name, style: AppTheme.resultTextStyle),
                          const SizedBox(height: 32),
                          _TraitList(
                            title: localizations.babyLoves,
                            items: _babyProfile!.loves.map((f) => f(localizations)).toList(),
                            iconPath: 'assets/images/icon_baby_bottle.png',
                            iconColor: Colors.pink,
                          ),
                          const SizedBox(height: 32),
                          _TraitList(
                            title: localizations.babyHates,
                            items: _babyProfile!.hates.map((f) => f(localizations)).toList(),
                            iconPath: 'assets/images/icon_baby_hates.png',
                            iconColor: Colors.green.shade700,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // Buttons floating at the bottom - NOT part of the shareable content
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Home button
                  OutlinedButton(
                    onPressed: () {
                      AudioService.instance.play(Sound.tap);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      foregroundColor: primaryColor,
                      minimumSize: const Size(double.infinity, 56),
                      side: const BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 5,
                    ),
                    child: Text(
                      localizations.homeButton,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: primaryColor, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Share button
                  ElevatedButton.icon(
                    onPressed: _shareResult,
                    icon: const Icon(Icons.share, color: Colors.black54),
                    label: Text(
                      localizations.shareAnnouncementButton,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black54, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Keep the existing _TraitList widget exactly the same
class _TraitList extends StatelessWidget {
  final String title;
  final List<String> items;
  final String iconPath;
  final Color iconColor;

  const _TraitList({required this.title, required this.items, required this.iconPath, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(iconPath, color: iconColor, height: 24),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        ...items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                      child: Image.asset(iconPath, color: iconColor.withOpacity(0.7), height: 18),
                    ),
                    Expanded(
                      child: Text(item, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade700)),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
