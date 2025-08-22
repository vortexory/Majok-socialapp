import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/providers/locale_provider.dart';
import 'package:futu/src/screens/onboarding_screen.dart';
import 'package:futu/src/screens/privacy_policy_screen.dart';
import 'package:futu/src/screens/terms_of_service_screen.dart';
import 'dart:ui'; // Import for BackdropFilter
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/services/storage_service.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryColor = Color(0xFF6A65F0);

    List<TextSpan> _buildLocalizedTitleSpans(BuildContext context) {
      final locale = Localizations.localeOf(context).languageCode;
      final text = AppLocalizations.of(context)!.welcomeMainTitle;

      if (locale == 'ar') {
        // Arabic
        final parts = text.split('ماجوك');
        return [
          TextSpan(text: parts[0]),
          TextSpan(
            text: 'ماجوك',
            style: const TextStyle(color: Colors.red),
          ),
          TextSpan(text: parts.length > 1 ? parts[1] : ''),
        ];
      } else {
        // English and other languages
        final parts = text.split('Majok');
        return [
          TextSpan(text: parts[0]),
          const TextSpan(
            text: 'Majok',
            style: TextStyle(color: Colors.red),
          ),
          TextSpan(text: parts.length > 1 ? parts[1] : ''),
        ];
      }
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset('assets/images/background.jpeg', fit: BoxFit.cover),

          // 2. Frosted Glass Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.4)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 3. UI Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 3),
                  Text(
                    AppLocalizations.of(context)!.welcomeTopTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 36,
                        height: 1.3,
                        shadows: [Shadow(color: Colors.black.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      children: _buildLocalizedTitleSpans(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.welcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.yellow),
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: SizedBox(
                      width: 220,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          AudioService.instance.play(Sound.transition);

                          // Track welcome screen interaction
                          await AnalyticsService.instance.logFeatureUsage('welcome_start_button', null);

                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OnboardingScreen()));
                        },
                        icon: const Icon(Icons.arrow_circle_right_outlined, color: Colors.white),
                        label: Text(
                          AppLocalizations.of(context)!.welcomeStartButton,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  Center(child: _LanguageSwitcher()),
                  const SizedBox(height: 20),
                  // Privacy Policy and Terms of Service Links
                  _PolicyLinks(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Privacy Policy and Terms of Service Links Widget
class _PolicyLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            AudioService.instance.play(Sound.tap);
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
          },
          child: Text(
            AppLocalizations.of(context)!.privacyPolicy,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70, decoration: TextDecoration.underline, decorationColor: Colors.white70),
          ),
        ),
        Text(' • ', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            AudioService.instance.play(Sound.tap);
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TermsOfServiceScreen()));
          },
          child: Text(
            AppLocalizations.of(context)!.termsOfService,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70, decoration: TextDecoration.underline, decorationColor: Colors.white70),
          ),
        ),
      ],
    );
  }
}

// A private helper widget for the language toggle button
class _LanguageSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);

    const activeColor = Color(0xFF6A65F0);
    const activeTextColor = Colors.white;
    final inactiveTextColor = Colors.grey.shade700;

    void toggleLanguage() async {
      AudioService.instance.play(Sound.tap);

      final fromLanguage = currentLocale.languageCode;
      String toLanguage;

      if (currentLocale.languageCode == 'en') {
        toLanguage = 'ar';
        localeNotifier.setLocale(const Locale('ar'));
      } else {
        toLanguage = 'en';
        localeNotifier.setLocale(const Locale('en'));
      }

      // Save language preference
      await StorageService.instance.setSelectedLanguage(toLanguage);

      // Track language change
      await AnalyticsService.instance.logLanguageChange(fromLanguage, toLanguage);
    }

    return GestureDetector(
      onTap: toggleLanguage,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: currentLocale.languageCode == 'en' ? 2 : 98,
              top: 2,
              bottom: 2,
              width: 98,
              child: Container(
                decoration: BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(28)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      AppLocalizations.of(context)!.languageEnglish,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: currentLocale.languageCode == 'en' ? activeTextColor : inactiveTextColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      AppLocalizations.of(context)!.languageArabic,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: currentLocale.languageCode == 'ar' ? activeTextColor : inactiveTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
