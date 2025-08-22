import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/models/romance_story_model.dart';
import 'package:futu/src/providers/user_state_provider.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/services/station_2_generator.dart';
import 'package:futu/src/services/share_service.dart';

class Station2ResultScreen extends ConsumerStatefulWidget {
  final String? selectedZodiac;
  final String selectedAnimal;
  final String selectedRide;
  final String dreamDestination;

  const Station2ResultScreen({
    Key? key,
    this.selectedZodiac,
    required this.selectedAnimal,
    required this.selectedRide,
    required this.dreamDestination,
  }) : super(key: key);

  @override
  ConsumerState<Station2ResultScreen> createState() => _Station2ResultScreenState();
}

class _Station2ResultScreenState extends ConsumerState<Station2ResultScreen> {
  RomanceStory? _romanceStory;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateResult();
    });
  }

  Future<void> _generateResult() async {
    try {
      print('Generating Station 2 result...'); // Debug

      final localizations = AppLocalizations.of(context)!;

      // Always generate a new result based on current choices
      // This ensures different choice combinations produce different results
      print(
        'Generating new story for choices: ${widget.selectedZodiac}, ${widget.selectedAnimal}, ${widget.selectedRide}, ${widget.dreamDestination}',
      ); // Debug

      // Generate new story based on user input
      final story = Station2Generator.instance.generateRomanceStory(
        localizations: localizations,
        selectedZodiac: widget.selectedZodiac,
        selectedAnimal: widget.selectedAnimal,
        selectedRide: widget.selectedRide,
        dreamDestination: widget.dreamDestination.isNotEmpty ? widget.dreamDestination : null,
        additionalInputs: {'generation_time': DateTime.now().toIso8601String()},
      );

      print('Generated story successfully'); // Debug

      // Save the result for consistency (will overwrite previous if exists)
      await Station2Generator.instance.saveResult(story);
      print('Saved result successfully'); // Debug

      setState(() {
        _romanceStory = story;
        _isLoading = false;
      });

      // Mark station as completed and unlock next station
      await ref.read(userStateProvider.notifier).updateStationStatus(2, 'completed');
      await ref.read(userStateProvider.notifier).updateStationStatus(3, 'unlocked');
      print('Updated station status'); // Debug

      // Track completion
      await AnalyticsService.instance.logStationComplete(2, 'Love Story');
      print('Logged analytics'); // Debug

      // Play reveal sound
      AudioService.instance.play(Sound.generalReveal);
    } catch (e, stackTrace) {
      print('Error in Station 2 _generateResult: $e');
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
      _romanceStory = null;
    });

    await _generateResult();
  }

  Future<void> _shareResult() async {
    if (_romanceStory == null) return;

    try {
      await AnalyticsService.instance.logShareAttempt(2, 'text', 'true');

      final localizations = AppLocalizations.of(context)!;
      final shareText =
          "${localizations.station2ResultTitle} 💕\n\n"
          "📖 ${localizations.storyHeadingMet}\n${_romanceStory!.howYouMet}\n\n"
          "💍 ${localizations.storyHeadingProposal}\n${_romanceStory!.theProposal}\n\n"
          "💒 ${localizations.storyHeadingWedding}\n${_romanceStory!.theWedding}\n\n"
          "#FutuApp #LoveStory #Romance";

      final success = await ShareService.instance.shareText(text: shareText, stationId: 2);

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
      print('Error sharing Station 2 result: $e');

      await AnalyticsService.instance.logShareAttempt(2, 'text', 'false');

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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
          centerTitle: true,
          title: Text(
            localizations.station2ResultTitle,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.black87),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/romance_background-1.jpg'), fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7), Colors.white.withOpacity(0.9)],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    localizations.generatingStoryMessage ?? 'Writing your love story...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null || _romanceStory == null) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
          centerTitle: true,
          title: Text(
            localizations.station2ResultTitle,
            // style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.black87),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/romance_background-1.jpg'), fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7), Colors.white.withOpacity(0.9)],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
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
                        'We couldn\'t write your love story. Please try again.',
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
            ),
          ],
        ),
      );
    }

    // ORIGINAL DESIGN - Restored exactly as it was
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Text(localizations.station2ResultTitle, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black87)),
      ),
      body: Stack(
        children: [
          // Background Image with a gradient overlay for text readability
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/romance_background-1.jpg'), fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7), Colors.white.withOpacity(0.9)],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Scrollable story content with share button at bottom
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    children: [
                      _StorySection(title: localizations.storyHeadingMet, content: _romanceStory!.howYouMet),
                      const SizedBox(height: 32),
                      _StorySection(title: localizations.storyHeadingProposal, content: _romanceStory!.theProposal),
                      const SizedBox(height: 32),
                      _StorySection(title: localizations.storyHeadingWedding, content: _romanceStory!.theWedding),
                      const SizedBox(height: 120), // Adjusted space for two buttons
                    ],
                  ),
                ),
                // Buttons at the bottom, inside the Stack to show background
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(bottom: 24.0),
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
                          backgroundColor: Colors.white.withOpacity(0.8),
                          foregroundColor: primaryColor,
                          minimumSize: const Size(double.infinity, 56),
                          side: const BorderSide(color: primaryColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(localizations.homeButton, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: primaryColor)),
                      ),
                      const SizedBox(height: 12),

                      // Share button - NOW SHARES TEXT ONLY
                      ElevatedButton.icon(
                        onPressed: _shareResult,
                        icon: const Icon(Icons.share, color: Colors.white),
                        label: Text(
                          localizations.shareAsImageButton,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// A helper widget for each section of the story - EXACTLY AS ORIGINAL
class _StorySection extends StatelessWidget {
  final String title;
  final String content;

  const _StorySection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black87)),
        const SizedBox(height: 12),
        Text(content, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
