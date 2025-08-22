import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider holds the logic for changing and persisting the app's locale.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  // We can add logic here later to load the saved language from the device.
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  // Default language is English.
  LocaleNotifier() : super(const Locale('en'));

  void setLocale(Locale newLocale) {
    if (state != newLocale) {
      state = newLocale;
      // Here we would save the new locale to the device's storage.
    }
  }
}