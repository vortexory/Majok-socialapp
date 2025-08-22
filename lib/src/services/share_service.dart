import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/services/storage_service.dart';
import 'package:futu/l10n/app_localizations.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  static ShareService get instance => _instance;

  /// Captures a widget as an image and shares it
  Future<bool> shareWidgetAsImage({
    required GlobalKey repaintBoundaryKey,
    required String filename,
    required String shareText,
    required int stationId,
    String? customText,
  }) async {
    try {
      // Find the RenderRepaintBoundary
      final RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Capture the image with high quality for social media
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get the temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/$filename.png');

      // Write the image to file
      await file.writeAsBytes(pngBytes);

      // Create engaging share text
      final finalShareText = customText ?? _getShareTextForStation(stationId, shareText);

      // Share the file
      await Share.shareXFiles([XFile(file.path)], text: finalShareText, subject: 'Check out my Mojak result! 💕✨');

      // Track analytics
      await AnalyticsService.instance.logResultShare(stationId, 'image');
      await StorageService.instance.incrementShareCount();

      return true;
    } catch (e) {
      debugPrint('Error sharing image: $e');
      return false;
    }
  }

  /// Shares just text without image
  Future<bool> shareText({required String text, required int stationId, String? customText}) async {
    try {
      final finalShareText = customText ?? _getShareTextForStation(stationId, text);

      await Share.share(finalShareText, subject: 'Check out my Mojak result! 💕');

      // Track analytics
      await AnalyticsService.instance.logResultShare(stationId, 'text');
      await StorageService.instance.incrementShareCount();

      return true;
    } catch (e) {
      debugPrint('Error sharing text: $e');
      return false;
    }
  }

  /// Creates a shareable image widget with station-specific branding
  Widget createShareableResultWidget({
    required Widget child,
    required int stationId,
    String? stationTitle,
    bool includeAppBranding = true,
  }) {
    return Container(
      width: 400, // Fixed width for consistent sharing
      decoration: BoxDecoration(gradient: _getGradientForStation(stationId), borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Station header if provided
          if (stationTitle != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Text(
                stationTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)],
                ),
              ),
            ),
          ],

          // Main content with white background
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: child,
          ),

          // App branding
          if (includeAppBranding) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite, color: Color(0xFF6A65F0), size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          'Made with Mojak App',
                          style: TextStyle(color: Color(0xFF6A65F0), fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Creates a beautiful story share widget for Station 2
  Widget createStoryShareWidget({required String title, required String story, required AppLocalizations localizations}) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        image: const DecorationImage(image: AssetImage('assets/images/romance_background-1.jpg'), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6A65F0)),
            ),
            const SizedBox(height: 12),
            Text(
              story,
              style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Text(
                  'My Love Story',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a baby announcement share widget for Station 3
  Widget createBabyAnnouncementWidget({required String babyName, required List<String> loves, required AppLocalizations localizations}) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFDAE19B), borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Baby avatar placeholder
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.yellow.shade200,
            child: const Icon(Icons.child_care, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 16),

          // Announcement text
          const Text(
            "👶 Baby Reveal! 👶",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text(
                  babyName,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE94057)),
                ),
                const SizedBox(height: 12),
                Text(
                  "Loves: ${loves.take(2).join(' & ')}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get station-specific gradient
  LinearGradient _getGradientForStation(int stationId) {
    switch (stationId) {
      case 1:
        return const LinearGradient(colors: [Color(0xFF6A65F0), Color(0xFF9C88FF)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case 2:
        return const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFF27121)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case 3:
        return const LinearGradient(colors: [Color(0xFFDAE19B), Color(0xFFA8E6CF)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case 4:
        return const LinearGradient(colors: [Color(0xFF6A65F0), Color(0xFF8E44AD)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case 5:
        return const LinearGradient(
          colors: [Color(0xFF0B0217), Color(0xFF281A4B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(colors: [Color(0xFF6A65F0), Color(0xFF9C88FF)], begin: Alignment.topLeft, end: Alignment.bottomRight);
    }
  }

  /// Get engaging share text for each station
  String _getShareTextForStation(int stationId, String defaultText) {
    switch (stationId) {
      case 1:
        return "🔮 Just discovered my soulmate's traits with Mojak! The results are so accurate it's spooky... 💕\n\n$defaultText\n\n#FutuApp #Soulmate #LoveReading";
      case 2:
        return "📖 My personalized love story from Mojak is absolutely magical! ✨ Every detail feels like it's meant to be...\n\n$defaultText\n\n#LoveStory #FutuApp #Romance";
      case 3:
        return "👶 Mojak just revealed our future baby and I'm CRYING! This is too cute! 🥺💕\n\n$defaultText\n\n#BabyReveal #FutuApp #FamilyGoals";
      case 4:
        return "💬 Had the sweetest conversation with my AI soulmate on Mojak! The chemistry is real! 😍\n\n$defaultText\n\n#Soulmate #FutuApp #LoveConnection";
      case 5:
        return "⭐ Found my PERFECT MATCH on Mojak! 99% compatibility?! Universe, you're amazing! 🌟💕\n\n$defaultText\n\n#PerfectMatch #FutuApp #Soulmate #Destiny";
      default:
        return "💕 Just tried Mojak and the results blew my mind! Check this out...\n\n$defaultText\n\n#FutuApp #SoulmateSearch";
    }
  }
}
