import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/providers/locale_provider.dart';
import 'package:futu/src/screens/welcome_screen.dart';
import 'package:futu/src/screens/main_screen.dart';
import 'package:futu/src/theme/app_theme.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/services/ad_service.dart';
import 'package:futu/src/services/storage_service.dart';
import 'package:futu/src/providers/user_state_provider.dart';

void main() async {
  // Ensure that widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize all services
  await StorageService.instance.initialize();
  await AnalyticsService.instance.initialize();
  await AdService.instance.initialize();

  // Log app open
  await AnalyticsService.instance.logAppOpen();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the current locale and rebuild when it changes
    final locale = ref.watch(localeProvider);
    final userState = ref.watch(userStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mojak',
      theme: AppTheme.theme,

      // ===== LOCALE CONFIGURATION =====
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // ================================

      // Add Firebase Analytics observer
      navigatorObservers: [AnalyticsService.instance.observer],

      home: _getInitialScreen(userState),
    );
  }

  Widget _getInitialScreen(UserState userState) {
    final isFirstLaunch = StorageService.instance.isFirstLaunch;

    if (isFirstLaunch) {
      // Track first launch
      AnalyticsService.instance.logFirstLaunch();
      StorageService.instance.setFirstLaunchComplete();
      return const WelcomeScreen();
    } else if (!userState.isOnboardingComplete) {
      return const WelcomeScreen();
    } else {
      // Returning user - go directly to main screen
      AnalyticsService.instance.logReturningUser();
      return const MainScreen();
    }
  }
}
