import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/models/partner_traits_model.dart';
import 'package:futu/src/providers/user_state_provider.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/services/station_1_generator.dart';
import 'package:futu/src/services/share_service.dart';
import 'package:futu/src/services/storage_service.dart';

class Station1ResultScreen extends ConsumerStatefulWidget {
  final String selectedDestiny;
  final int heartsCaught;
  final int timeSpent;

  const Station1ResultScreen({Key? key, required this.selectedDestiny, required this.heartsCaught, required this.timeSpent})
    : super(key: key);

  @override
  ConsumerState<Station1ResultScreen> createState() => _Station1ResultScreenState();
}

class _Station1ResultScreenState extends ConsumerState<Station1ResultScreen> {
  PartnerTraits? _partnerTraits;
  bool _isLoading = true;
  String? _errorMessage;

  // Key for capturing the shareable content
  final GlobalKey _shareableKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Add a small delay to ensure the context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateResult();
    });
  }

  Future<void> _generateResult() async {
    try {
      print('Starting result generation...'); // Debug

      final localizations = AppLocalizations.of(context)!;
      print('Got localizations'); // Debug

      // Always generate a new result based on current choices
      // This ensures different destiny choices produce different results
      print('Generating new result for destiny: ${widget.selectedDestiny}'); // Debug

      // Generate new result based on user input
      final traits = Station1Generator.instance.generatePartnerTraits(
        localizations: localizations,
        selectedDestiny: widget.selectedDestiny,
        additionalInputs: {'hearts_caught': widget.heartsCaught, 'time_spent': widget.timeSpent},
      );

      print('Generated traits successfully'); // Debug

      // Save the result for consistency (will overwrite previous if exists)
      await Station1Generator.instance.saveResult(traits);
      print('Saved result successfully'); // Debug

      setState(() {
        _partnerTraits = traits;
        _isLoading = false;
      });

      // Mark station as completed and unlock next station
      await ref.read(userStateProvider.notifier).updateStationStatus(1, 'completed');
      await ref.read(userStateProvider.notifier).updateStationStatus(2, 'unlocked');
      print('Updated station status'); // Debug

      // Track completion
      await AnalyticsService.instance.logStationComplete(1, 'Partner Traits');
      print('Logged analytics'); // Debug

      // Play reveal sound
      AudioService.instance.play(Sound.generalReveal);
    } catch (e, stackTrace) {
      print('Error in _generateResult: $e');
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
      _partnerTraits = null;
    });

    await _generateResult();
  }

  Future<void> _shareResult() async {
    if (_partnerTraits == null) return;

    try {
      // Fixed: Pass string instead of boolean for success parameter
      await AnalyticsService.instance.logShareAttempt(1, 'image', 'true');

      final localizations = AppLocalizations.of(context)!;
      final shareText =
          "${localizations.station1ResultTitle}\n\n"
          "${localizations.traitHeight}: ${_partnerTraits!.height}\n"
          "${localizations.traitEyeColor}: ${_partnerTraits!.eyeColor}\n"
          "${localizations.traitHobbies}: ${_partnerTraits!.hobbies}";

      final success = await ShareService.instance.shareWidgetAsImage(
        repaintBoundaryKey: _shareableKey,
        filename: 'futu_soulmate_traits_${DateTime.now().millisecondsSinceEpoch}',
        shareText: shareText,
        stationId: 1,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? (localizations.shareSuccessMessage) : (localizations.shareErrorMessage)),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error sharing result: $e');

      // Log failed share attempt with string value
      await AnalyticsService.instance.logShareAttempt(1, 'image', 'false');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to share. Please try again.'), backgroundColor: Colors.red));
      }
    }
  }

  // Add method to clear saved results for testing
  Future<void> _clearSavedResults() async {
    try {
      // Clear station 1 results from storage
      final currentResults = StorageService.instance.getStationResults();
      currentResults.remove(1);

      // Save the updated results map
      await StorageService.instance.saveStationResult(1, {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Previous results cleared! Go back and try different choices.'), backgroundColor: Colors.green),
      );
    } catch (e) {
      print('Error clearing results: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const primaryButtonColor = Color(0xFF6A65F0);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.resultAppBarTitle, style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          // Add debug button to clear results for testing
          IconButton(icon: const Icon(Icons.refresh), onPressed: _clearSavedResults, tooltip: 'Clear saved results (for testing)'),
        ],
      ),
      backgroundColor: Colors.white,
      body: _buildBody(context, localizations, primaryButtonColor),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations localizations, Color primaryButtonColor) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: primaryButtonColor),
            const SizedBox(height: 16),
            Text(localizations.generatingResultMessage, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
          ],
        ),
      );
    }

    if (_errorMessage != null || _partnerTraits == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Oops! Something went wrong', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'We couldn\'t generate your soulmate\'s traits. Please try again.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Error: $_errorMessage',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _retryGeneration,
                    style: ElevatedButton.styleFrom(backgroundColor: primaryButtonColor),
                    child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(foregroundColor: primaryButtonColor),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Show current choice for debugging
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Text('Your Choices:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Destiny: ${widget.selectedDestiny} | Hearts: ${widget.heartsCaught}/10 | Time: ${widget.timeSpent}s',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Shareable content wrapped in RepaintBoundary
            RepaintBoundary(
              key: _shareableKey,
              child: ShareService.instance.createShareableResultWidget(
                stationId: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 24.0), // Added top padding to compensate for missing title
                  child: Column(
                    children: [
                      Image.asset('assets/images/partner_traits_hero.png', height: 120),
                      const SizedBox(height: 16), // Keep original spacing
                      // Trait cards - removed the station title section
                      _TraitInfoCard(
                        iconPath: 'assets/images/icon_height.png',
                        label: localizations.traitHeight,
                        value: _partnerTraits!.height,
                      ),
                      _TraitInfoCard(
                        iconPath: 'assets/images/icon_weight.png',
                        label: localizations.traitWeight,
                        value: _partnerTraits!.weight,
                      ),
                      _TraitInfoCard(
                        iconPath: 'assets/images/icon_eye.png',
                        label: localizations.traitEyeColor,
                        value: _partnerTraits!.eyeColor,
                      ),
                      _TraitInfoCard(
                        iconPath: 'assets/images/icon_hobbies.png',
                        label: localizations.traitHobbies,
                        value: _partnerTraits!.hobbies,
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),

                      // Funny Quirks Section
                      Text(localizations.funnyQuirksTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54)),
                      const SizedBox(height: 8),
                      ..._partnerTraits!.funnyQuirks
                          .take(2)
                          .map(
                            (quirk) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  const Icon(Icons.sentiment_very_satisfied, color: Colors.orange, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      quirk,
                                      style: Theme.of(context).textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: OutlinedButton(
                onPressed: () {
                  AudioService.instance.play(Sound.tap);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryButtonColor,
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(color: primaryButtonColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(localizations.homeButton),
              ),
            ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton.icon(
                onPressed: _shareResult,
                icon: const Icon(Icons.share, color: Colors.white),
                label: Text(localizations.shareButton, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryButtonColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Keep the existing _TraitInfoCard widget exactly the same
class _TraitInfoCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const _TraitInfoCard({required this.iconPath, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.lightGreen.shade100, child: Image.asset(iconPath, height: 20)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
