import 'dart:async';
import 'package:flutter/material.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/screens/station_3/station_3_result_screen.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';

class Station3ChallengeScreen extends StatefulWidget {
  const Station3ChallengeScreen({Key? key}) : super(key: key);
  @override
  _Station3ChallengeScreenState createState() => _Station3ChallengeScreenState();
}

class _Station3ChallengeScreenState extends State<Station3ChallengeScreen> {
  double _progress = 0.0; // From 0.0 to 1.0
  bool _isComplete = false;
  late DateTime _startTime;
  int _totalTaps = 0;

  // Define how many taps it takes to fill the bottle
  static const int _tapsToFill = 20;
  static const double _increment = 1.0 / _tapsToFill;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Track station start
    AnalyticsService.instance.logStationStart(3, 'Baby Profile Generation');

    // Track game start
    AnalyticsService.instance.logGameInteraction(gameType: 'bottle_filling', action: 'start');
  }

  void _fillBottle() {
    if (_isComplete) return; // Prevent more taps after completion

    AudioService.instance.play(Sound.tap);

    setState(() {
      _totalTaps++;
      _progress += _increment;
      if (_progress >= 1.0) {
        _progress = 1.0;
        _isComplete = true;
        _onComplete();
      }
    });
  }

  void _onComplete() {
    AudioService.instance.play(Sound.generalReveal);

    // Calculate game metrics
    final timeSpent = DateTime.now().difference(_startTime).inSeconds;

    // Track game completion
    AnalyticsService.instance.logGameInteraction(
      gameType: 'bottle_filling',
      action: 'complete',
      score: _totalTaps,
      timeSpent: timeSpent,
      additionalData: {'completion_percentage': 100, 'taps_required': _tapsToFill, 'taps_actual': _totalTaps},
    );

    // Wait for a brief moment so the user can see the "100%"
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => Station3ResultScreen(
              heartsCaught: _totalTaps, // Using taps as "hearts caught" for generation
              timeSpent: timeSpent,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF6A65F0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(localizations.station3AppBarTitle, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(localizations.station3ChallengeTitle, style: Theme.of(context).textTheme.headlineSmall),

            // The Baby Bottle Widget
            SizedBox(
              width: 200,
              height: 300,
              child: ClipPath(
                clipper: _BottleClipper(),
                child: Stack(
                  children: [
                    // The bottle outline/background
                    Container(color: Colors.grey.shade200),
                    // The animated "milk" filling
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 300 * _progress,
                        color: primaryColor.withOpacity(0.5),
                      ),
                    ),
                    // The nipple part (static)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(color: Colors.grey.shade400, shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Progress Bar and Text
            Column(
              children: [
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey.shade200,
                  color: primaryColor,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 12),
                Text(
                  localizations.station3ProgressLabel((_progress * 100).toInt().toString()),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            // Tap Button
            ElevatedButton(
              onPressed: _isComplete ? null : _fillBottle,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: Text(
                localizations.station3ChallengeButton,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Keep the existing _BottleClipper exactly the same
class _BottleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double w = size.width;
    double h = size.height;

    path.moveTo(w * 0.15, h); // Bottom-left
    path.lineTo(w * 0.15, h * 0.25); // Up to left shoulder
    path.quadraticBezierTo(w * 0.2, h * 0.1, w * 0.4, h * 0.1); // Curve to nipple base
    path.lineTo(w * 0.4, 0); // Up to top-left of nipple
    path.lineTo(w * 0.6, 0); // Across nipple top
    path.lineTo(w * 0.6, h * 0.1); // Down to nipple base
    path.quadraticBezierTo(w * 0.8, h * 0.1, w * 0.85, h * 0.25); // Curve to right shoulder
    path.lineTo(w * 0.85, h); // Down to bottom-right
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
