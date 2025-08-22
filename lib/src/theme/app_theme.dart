// In lib/src/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6A65F0);
  static const Color accentColor = Color(0xFFE94057);

  static ThemeData get theme {
    // 1. Define base text themes for our "workhorse" fonts.
    // Poppins for LTR languages, Cairo for RTL.
    // final baseTextTheme = GoogleFonts.poppinsTextTheme();
    final baseTextTheme = GoogleFonts.patrickHandTextTheme();
    final baseArabicTextTheme = GoogleFonts.cairoTextTheme();

    // 2. Start with a base ThemeData object.
    final theme = ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      // Default font will be Poppins, but TextDirection will handle Arabic fallback.
      // fontFamily: GoogleFonts.poppins().fontFamily,
      fontFamily: GoogleFonts.patrickHand().fontFamily, 
    );

    // 3. Customize the theme's TextTheme for both LTR and RTL.
    return theme.copyWith(
      textTheme: baseTextTheme
          .copyWith(
            // --- DISPLAY FONTS (As per Client Request) ---

            // For major screen titles (e.g., AppBar titles)
            headlineMedium: GoogleFonts.titanOne(textStyle: baseTextTheme.headlineMedium?.copyWith(fontSize: 16)),

            // For titles inside cards (e.g., "Celebrity Scoop!")
            titleLarge: GoogleFonts.titanOne(textStyle: baseTextTheme.titleLarge?.copyWith(fontSize: 20)),

            // --- WORKHORSE FONT STYLES (Poppins / Cairo) ---

            // For section titles (e.g., "What's your Zodiac Sign?")
            // headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            headlineSmall: GoogleFonts.titanOne(textStyle: baseTextTheme.headlineSmall),

            // For general-purpose labels within cards (e.g., "Height", "Weight")
            // titleMedium: baseTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            titleMedium: GoogleFonts.titanOne(textStyle: baseTextTheme.titleMedium),

            // For subtitles and descriptions (e.g., "Pick your happiest hue.")
            titleSmall: baseTextTheme.titleSmall?.copyWith(color: Colors.grey.shade600, fontSize: 18,),

            // For main paragraph/body text.
            bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 18, height: 1.5),

            // For smaller body text or captions (e.g., progress labels)
            bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: Colors.grey.shade700, fontSize: 18),

            // For button text
            labelLarge: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          )
          .apply(
            // This ensures that for Arabic, all our Poppins styles are replaced by Cairo.
            fontFamilyFallback: [GoogleFonts.cairo().fontFamily!],
          ),
    );
  }

  // --- SPECIAL TEXT STYLE FOR RESULTS (Knewave) ---
  static TextStyle get resultTextStyle {
    return GoogleFonts.knewave(fontSize: 36, fontWeight: FontWeight.bold, color: accentColor);
  }
}
