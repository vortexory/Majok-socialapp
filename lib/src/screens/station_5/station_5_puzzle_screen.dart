import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/screens/station_5/station_5_final_reveal_screen.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/theme/app_theme.dart';

class Station5PuzzleScreen extends StatefulWidget {
  const Station5PuzzleScreen({Key? key}) : super(key: key);

  @override
  _Station5PuzzleScreenState createState() => _Station5PuzzleScreenState();
}

class _Station5PuzzleScreenState extends State<Station5PuzzleScreen> {
  // The fixed positions of the stars in the constellation
  final List<Offset> _starPositions = [];
  // The indices of the stars that have been successfully connected
  final List<int> _connectedIndices = [0]; // Start with the first star connected
  // The current position of the user's finger while dragging
  Offset? _currentDragPosition;
  // The index of the next star the user needs to connect to
  int _nextStarIndex = 1;
  // For creating the pulsing glow animation on the next star
  bool _isGlowing = false;
  Timer? _glowTimer;
  // Tracks if the puzzle is complete to trigger the final animation
  bool _isComplete = false;

  // State for showing the instructional hint
  bool _showHint = true;

  // Responsive dimensions
  double _starSize = 30.0;
  double _touchRadius = 30.0;
  double _strokeWidth = 2.0;

  // Track game metrics for generation
  late DateTime _startTime;
  int _totalConnections = 0;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Track station start
    AnalyticsService.instance.logStationStart(5, 'Final Soulmate Reveal');

    // Track puzzle start
    AnalyticsService.instance.logGameInteraction(gameType: 'constellation_tracing', action: 'start');

    // Start the pulsing animation timer
    _glowTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() => _isGlowing = !_isGlowing);
      }
    });

    // Hide the hint automatically after 7 seconds
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted && _showHint) {
        setState(() {
          _showHint = false;
        });
      }
    });
  }

  // Initialize star positions based on screen size with responsive positioning
  void _initializeStars(Size size) {
    if (_starPositions.isEmpty) {
      // Calculate responsive dimensions
      final minDimension = size.width < size.height ? size.width : size.height;
      _starSize = (minDimension * 0.06).clamp(20.0, 40.0);
      _touchRadius = _starSize * 1.2;
      _strokeWidth = (minDimension * 0.004).clamp(1.5, 4.0);

      // Calculate safe area margins to keep stars away from edges
      final horizontalMargin = size.width * 0.1;
      final verticalMargin = size.height * 0.15; // More margin at top for app bar
      final bottomMargin = size.height * 0.12; // Margin at bottom for hint

      // Available area for constellation
      final availableWidth = size.width - (horizontalMargin * 2);
      final availableHeight = size.height - verticalMargin - bottomMargin;
      final startX = horizontalMargin;
      final startY = verticalMargin;

      // Create heart shape with responsive positioning
      _starPositions.addAll([
        Offset(startX + availableWidth * 0.5, startY + availableHeight * 0.85), // 0: Bottom point
        Offset(startX + availableWidth * 0.2, startY + availableHeight * 0.6), // 1: Lower left
        Offset(startX + availableWidth * 0.1, startY + availableHeight * 0.4), // 2: Upper left
        Offset(startX + availableWidth * 0.25, startY + availableHeight * 0.2), // 3: Top left curve
        Offset(startX + availableWidth * 0.5, startY + availableHeight * 0.35), // 4: Top center dip
        Offset(startX + availableWidth * 0.75, startY + availableHeight * 0.2), // 5: Top right curve
        Offset(startX + availableWidth * 0.9, startY + availableHeight * 0.4), // 6: Upper right
        Offset(startX + availableWidth * 0.8, startY + availableHeight * 0.6), // 7: Lower right
      ]);
    }
  }

  void _onPanStart(DragStartDetails details) {
    final touchPos = details.localPosition;
    final startStarPos = _starPositions[_connectedIndices.last];
    // Start dragging only if the user touches near the last connected star
    if ((touchPos - startStarPos).distance < _touchRadius) {
      setState(() => _currentDragPosition = touchPos);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_currentDragPosition != null) {
      setState(() => _currentDragPosition = details.localPosition);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentDragPosition == null || _nextStarIndex >= _starPositions.length) {
      setState(() => _currentDragPosition = null);
      return;
    }

    final nextStarPos = _starPositions[_nextStarIndex];
    // Check if the user's finger is close enough to the next star
    if ((_currentDragPosition! - nextStarPos).distance < _touchRadius) {
      AudioService.instance.play(Sound.tap);

      setState(() {
        _connectedIndices.add(_nextStarIndex);
        _nextStarIndex++;
        _totalConnections++;

        // Hide the hint as soon as the user makes their first connection
        if (_showHint) {
          _showHint = false;
        }

        // Check for puzzle completion
        if (_nextStarIndex >= _starPositions.length) {
          _onComplete();
        }
      });
    }
    setState(() => _currentDragPosition = null);
  }

  void _onComplete() {
    // Add the first star again to close the heart shape
    _connectedIndices.add(0);
    _isComplete = true;
    _glowTimer?.cancel();

    // Calculate completion time
    final completionTime = DateTime.now().difference(_startTime).inSeconds;

    // Track puzzle completion
    AnalyticsService.instance.logGameInteraction(
      gameType: 'constellation_tracing',
      action: 'complete',
      timeSpent: completionTime,
      additionalData: {'total_connections': _totalConnections, 'completion_time': completionTime, 'puzzle_completed': true},
    );

    AudioService.instance.play(Sound.finalReveal);

    // Trigger final animation and navigate
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        AudioService.instance.play(Sound.transition);

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                Station5FinalRevealScreen(constellationTime: completionTime, puzzleCompleted: true),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _glowTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360 || screenHeight < 640;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          localizations.station5PuzzleTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white70, fontSize: isSmallScreen ? 18 : null),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF0b0217), Color(0xFF281a4b)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            _initializeStars(constraints.biggest);
            return GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Stack(
                children: [
                  // The custom painter for drawing lines
                  CustomPaint(
                    size: Size.infinite,
                    painter: _ConstellationPainter(
                      stars: _starPositions,
                      connectedIndices: _connectedIndices,
                      dragPosition: _currentDragPosition,
                      isComplete: _isComplete,
                      strokeWidth: _strokeWidth,
                    ),
                  ),
                  // The interactive star widgets
                  ..._starPositions.asMap().entries.map((entry) {
                    int index = entry.key;
                    Offset pos = entry.value;
                    bool isConnected = _connectedIndices.contains(index);
                    bool isNext = index == _nextStarIndex;

                    return Positioned(
                      left: pos.dx - _starSize / 2,
                      top: pos.dy - _starSize / 2,
                      child: _StarWidget(isGlowing: isNext && _isGlowing, isComplete: isConnected, size: _starSize),
                    );
                  }),

                  // Responsive hint widget at the bottom
                  AnimatedOpacity(
                    opacity: _showHint ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).padding.bottom + (isSmallScreen ? 20 : 30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16, vertical: isSmallScreen ? 8 : 10),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.25), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.touch_app_outlined, color: Colors.white70, size: isSmallScreen ? 18 : 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                localizations.station5PuzzleHint,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(color: Colors.white70, fontSize: isSmallScreen ? 12 : null),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// A widget to represent a single star
class _StarWidget extends StatelessWidget {
  final bool isGlowing;
  final bool isComplete;
  final double size;

  const _StarWidget({this.isGlowing = false, this.isComplete = false, this.size = 30.0});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          if (isComplete) BoxShadow(color: Colors.white, blurRadius: size * 0.33, spreadRadius: size * 0.07),
          if (isGlowing) BoxShadow(color: Colors.yellow.shade300, blurRadius: size * 0.67, spreadRadius: size * 0.17),
        ],
      ),
    );
  }
}

// The custom painter that draws the lines
class _ConstellationPainter extends CustomPainter {
  final List<Offset> stars;
  final List<int> connectedIndices;
  final Offset? dragPosition;
  final bool isComplete;
  final double strokeWidth;

  _ConstellationPainter({
    required this.stars,
    required this.connectedIndices,
    this.dragPosition,
    this.isComplete = false,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final connectedPaint = Paint()
      ..color = Colors.white.withOpacity(isComplete ? 1.0 : 0.7)
      ..strokeWidth = isComplete ? strokeWidth * 2 : strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = isComplete
          ? const LinearGradient(colors: [Colors.yellowAccent, Colors.white]).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          : null;

    final draggingPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw the lines for already connected stars
    for (int i = 0; i < connectedIndices.length - 1; i++) {
      final start = stars[connectedIndices[i]];
      final end = stars[connectedIndices[i + 1]];
      canvas.drawLine(start, end, connectedPaint);
    }

    // Draw the line that follows the user's finger
    if (dragPosition != null && connectedIndices.isNotEmpty) {
      final lastConnectedStar = stars[connectedIndices.last];
      canvas.drawLine(lastConnectedStar, dragPosition!, draggingPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
