import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/providers/user_state_provider.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/services/station_5_generator.dart';
import 'package:futu/src/services/share_service.dart';
import 'package:futu/src/theme/app_theme.dart';
import 'package:futu/src/widgets/banner_ad_widget.dart';

class Station5FinalRevealScreen extends ConsumerStatefulWidget {
  final int constellationTime;
  final bool puzzleCompleted;

  const Station5FinalRevealScreen({Key? key, required this.constellationTime, required this.puzzleCompleted}) : super(key: key);

  @override
  ConsumerState<Station5FinalRevealScreen> createState() => _Station5FinalRevealScreenState();
}

class _Station5FinalRevealScreenState extends ConsumerState<Station5FinalRevealScreen> {
  Map<String, dynamic>? _finalResult;
  bool _isLoading = true;
  String? _errorMessage;

  // Key for capturing the shareable content
  final GlobalKey _shareableKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioService.instance.play(Sound.finalReveal);
      _generateFinalResult();
    });
  }

  Future<void> _generateFinalResult() async {
    try {
      print('Generating Station 5 final result...'); // Debug

      final localizations = AppLocalizations.of(context)!;

      // Always generate new result based on current puzzle performance
      print('Generating final reveal for constellation time: ${widget.constellationTime}s, completed: ${widget.puzzleCompleted}'); // Debug

      // Generate final reveal based on user performance
      final finalResult = Station5Generator.instance.generateFinalReveal(
        localizations: localizations,
        constellationTime: widget.constellationTime,
        puzzleCompleted: widget.puzzleCompleted,
        additionalInputs: {'generation_time': DateTime.now().toIso8601String()},
      );

      print('Generated final result successfully'); // Debug

      // Save the result for consistency
      await Station5Generator.instance.saveResult(finalResult);
      print('Saved result successfully'); // Debug

      setState(() {
        _finalResult = finalResult;
        _isLoading = false;
      });

      // Mark station as completed (final station)
      await ref.read(userStateProvider.notifier).updateStationStatus(5, 'completed');
      print('Updated station status'); // Debug

      // Track completion
      await AnalyticsService.instance.logStationComplete(5, 'Final Soulmate Reveal');
      print('Logged analytics'); // Debug
    } catch (e, stackTrace) {
      print('Error in Station 5 _generateFinalResult: $e');
      print('Stack trace: $stackTrace');

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _shareResult() async {
    if (_finalResult == null) return;

    try {
      await AnalyticsService.instance.logShareAttempt(5, 'image', 'true');

      final localizations = AppLocalizations.of(context)!;
      final partnerName = _finalResult!['partner_name'] ?? 'Fatima';
      final matchPercentage = _finalResult!['match_percentage'] ?? 89;
      final loves = List<String>.from(_finalResult!['loves'] ?? []);
      final hates = List<String>.from(_finalResult!['hates'] ?? []);

      final shareText =
          "${localizations.finalRevealTitle} ⭐\n\n"
          "Perfect Match Found: $partnerName\n"
          "$matchPercentage% Compatibility! 💕\n\n"
          "${localizations.resultLoves}: ${loves.take(2).join(', ')}\n"
          "${localizations.resultHates}: ${hates.take(2).join(', ')}\n\n"
          "#FutuApp #PerfectMatch #Soulmate #Destiny";

      final success = await ShareService.instance.shareWidgetAsImage(
        repaintBoundaryKey: _shareableKey,
        filename: 'futu_perfect_match_${DateTime.now().millisecondsSinceEpoch}',
        shareText: shareText,
        stationId: 5,
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
      print('Error sharing Station 5 result: $e');

      await AnalyticsService.instance.logShareAttempt(5, 'image', 'false');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to share. Please try again.'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6A65F0);
    final localizations = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(localizations.finalRevealTitle, style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: primaryColor),
              SizedBox(height: 16),
              Text(
                'Revealing your perfect match...',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null || _finalResult == null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(localizations.finalRevealTitle, style: Theme.of(context).textTheme.headlineMedium),
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
                  'Reveal Failed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We couldn\'t reveal your perfect match. Please try again.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                        });
                        _generateFinalResult();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                      child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(foregroundColor: primaryColor),
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

    // Extract data from final result
    final matchName = _finalResult!['partner_name'] ?? 'Fatima';
    final matchPercentage = _finalResult!['match_percentage'] ?? 89;
    final loves = List<String>.from(_finalResult!['loves'] ?? []);
    final hates = List<String>.from(_finalResult!['hates'] ?? []);
    final avatarPath = _finalResult!['avatar_path'] ?? 'assets/images/avatar_fatima.png';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(localizations.finalRevealTitle, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Wrap the main content in RepaintBoundary for sharing
              RepaintBoundary(
                key: _shareableKey,
                child: Container(
                  color: Colors.grey.shade100, // Ensure background color is captured
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 60),
                        padding: const EdgeInsets.fromLTRB(24, 84, 24, 24),
                        decoration: BoxDecoration(
                          image: const DecorationImage(image: AssetImage('assets/images/hearts_background.png'), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
                        ),
                        child: Column(
                          children: [
                            Text(matchName, style: AppTheme.resultTextStyle.copyWith(color: Colors.black, fontSize: 32)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                localizations.resultMatchChip(matchPercentage.toString()),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildTraitRow(
                              context: context,
                              label: localizations.resultLoves,
                              traits: loves.join(', '),
                              labelColor: Colors.red.shade300,
                            ),
                            const SizedBox(height: 12),
                            _buildTraitRow(
                              context: context,
                              label: localizations.resultHates,
                              traits: hates.join(', '),
                              labelColor: Colors.grey.shade500,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(radius: 60, backgroundImage: AssetImage(avatarPath)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Action buttons - NOT part of the shareable content
              OutlinedButton.icon(
                onPressed: () {
                  AudioService.instance.play(Sound.tap);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home_outlined),
                label: Text(localizations.homeButton, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: primaryColor)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(color: primaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              // const SizedBox(height: 12),

              // OutlinedButton.icon(
              //   onPressed: () {
              //     AudioService.instance.play(Sound.tap);
              //     _shareResult();
              //   },
              //   icon: const Icon(Icons.save_alt),
              //   label: Text(
              //     localizations.saveToGalleryButton,
              //     style: Theme.of(context).textTheme.labelLarge?.copyWith(color: primaryColor),
              //   ),
              //   style: OutlinedButton.styleFrom(
              //     foregroundColor: primaryColor,
              //     minimumSize: const Size(double.infinity, 56),
              //     side: BorderSide(color: primaryColor, width: 1.5),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              //   ),
              // ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _shareResult,
                icon: const Icon(Icons.share, color: Colors.white),
                label: Text(localizations.resultShareButton, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BannerAdWidget(placement: 'station_5_result'),
    );
  }

  // Helper widget remains the same
  Widget _buildTraitRow({required BuildContext context, required String label, required String traits, required Color labelColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: labelColor),
        ),
        Expanded(
          child: Text(traits, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87)),
        ),
      ],
    );
  }
}
