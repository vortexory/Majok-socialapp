import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/src/models/user_profile_model.dart';
import 'package:futu/src/services/storage_service.dart';

// This provider will hold the state of the user's profile.
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

class UserProfileNotifier extends StateNotifier<UserProfile> {
  // Initialize with data from storage or placeholder if none exists.
  UserProfileNotifier() : super(_loadUserProfile());

  static UserProfile _loadUserProfile() {
    final userData = StorageService.instance.getUserProfile();

    if (userData.isEmpty) {
      return UserProfile.placeholder();
    }

    return UserProfile(
      name: userData['name']?.toString() ?? 'Unknown User',
      age: userData['age'] ?? 25,
      height: userData['height'] ?? 175,
      gender: userData['gender']?.toString() ?? 'Not specified',
      hobbies: List<String>.from(userData['hobbies'] ?? []),
      photoUrl: userData['photo_url']?.toString(),
    );
  }

  // Method to update profile from onboarding data
  void updateFromOnboardingData(Map<String, dynamic> onboardingData) {
    state = UserProfile(
      name: onboardingData['name']?.toString() ?? state.name,
      age: onboardingData['age'] ?? state.age,
      height: onboardingData['height'] ?? state.height,
      gender: onboardingData['gender']?.toString() ?? state.gender,
      hobbies: List<String>.from(onboardingData['hobbies'] ?? state.hobbies),
      photoUrl: onboardingData['photo_url']?.toString() ?? state.photoUrl,
    );
  }

  // Method to refresh profile from storage
  void refreshFromStorage() {
    state = _loadUserProfile();
  }

  // Method to clear profile (for logout/reset)
  void clearProfile() {
    state = UserProfile.placeholder();
  }
}
