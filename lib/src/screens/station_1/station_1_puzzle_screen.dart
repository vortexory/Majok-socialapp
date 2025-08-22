import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/screens/station_1/station_1_result_screen.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';

// A small class to hold data for each heart
class Heart {
  final int id;
  final double x;
  double y;
  bool isCaught = false;

  Heart({required this.id, required this.x, this.y = -0.1});
}

class Station1PuzzleScreen extends StatefulWidget {
  final String selectedDestiny;

  const Station1PuzzleScreen({Key? key, required this.selectedDestiny}) : super(key: key);

  @override
  _Station1PuzzleScreenState createState() => _Station1PuzzleScreenState();
}

class _Station1PuzzleScreenState extends State<Station1PuzzleScreen> {
  // Game State
  int _secondsLeft = 5;
  int _heartsCaught = 0;
  final int _heartsToCatch = 10;
  final List<Heart> _heartsOnScreen = [];
  final Random _random = Random();

  // Timers
  Timer? _countdownTimer;
  Timer? _heartSpawner;

  @override
  void initState() {
    super.initState();
    _startGame();

    // Track puzzle start
    AnalyticsService.instance.logGameInteraction(
      gameType: 'heart_catching',
      action: 'start',
      additionalData: {'destiny': widget.selectedDestiny},
    );
  }

  void _startGame() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _endGame();
      }
    });

    _heartSpawner = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      _spawnHeart();
    });
  }

  void _spawnHeart() {
    if (!mounted) return;

    final id = DateTime.now().millisecondsSinceEpoch;
    final x = _random.nextDouble() * 0.9;
    final newHeart = Heart(id: id, x: x);

    setState(() {
      _heartsOnScreen.add(newHeart);
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      setState(() {
        newHeart.y = 1.1;
      });
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        _heartsOnScreen.removeWhere((h) => h.id == id);
      });
    });
  }

  void _catchHeart(int heartId) {
    final heart = _heartsOnScreen.firstWhere((h) => h.id == heartId);
    if (!heart.isCaught) {
      AudioService.instance.play(Sound.tap);
      setState(() {
        heart.isCaught = true;
        _heartsCaught++;
      });
    }
  }

  void _endGame() {
    _countdownTimer?.cancel();
    _heartSpawner?.cancel();

    // Track puzzle completion
    AnalyticsService.instance.logGameInteraction(
      gameType: 'heart_catching',
      action: 'complete',
      score: _heartsCaught,
      timeSpent: 5,
      additionalData: {'destiny': widget.selectedDestiny, 'hearts_caught': _heartsCaught, 'total_hearts': _heartsToCatch},
    );

    AudioService.instance.play(Sound.generalReveal);

    // Navigate to result screen with all the data
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Station1ResultScreen(selectedDestiny: widget.selectedDestiny, heartsCaught: _heartsCaught, timeSpent: 5),
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _heartSpawner?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(AppLocalizations.of(context)!.puzzleTitle, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFFF3B0), Color(0xFFF9C7D2)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Stack(
          children: [
            // Falling hearts
            ..._heartsOnScreen.map((heart) {
              return AnimatedPositioned(
                duration: const Duration(seconds: 4),
                curve: Curves.linear,
                top: size.height * heart.y,
                left: size.width * heart.x,
                child: GestureDetector(
                  onTap: () => _catchHeart(heart.id),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: heart.isCaught ? 0.0 : 1.0,
                    child: const Icon(Icons.favorite_border, color: Colors.red, size: 50),
                  ),
                ),
              );
            }).toList(),

            // Central Countdown Timer
            Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _secondsLeft.toString(),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    Text(
                      AppLocalizations.of(context)!.secondsLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

            // Score Counter
            Positioned(
              top: kToolbarHeight + 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "$_heartsCaught/$_heartsToCatch",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
