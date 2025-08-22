import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/src/services/storage_service.dart';

class UserStateNotifier extends StateNotifier<UserState> {
  UserStateNotifier() : super(UserState.initial()) {
    _loadUserState();
  }

  void _loadUserState() {
    final isOnboardingComplete = StorageService.instance.isOnboardingComplete;
    final userProfile = StorageService.instance.getUserProfile();
    final stationProgress = StorageService.instance.getStationProgress();

    state = state.copyWith(isOnboardingComplete: isOnboardingComplete, userProfile: userProfile, stationProgress: stationProgress);
  }

  Future<void> completeOnboarding(Map<String, dynamic> userProfile) async {
    await StorageService.instance.setOnboardingComplete();
    await StorageService.instance.saveUserProfile(userProfile);

    state = state.copyWith(isOnboardingComplete: true, userProfile: userProfile);
  }

  Future<void> updateStationStatus(int stationId, String status) async {
    await StorageService.instance.setStationStatus(stationId, status);

    final updatedProgress = Map<int, String>.from(state.stationProgress);
    updatedProgress[stationId] = status;

    state = state.copyWith(stationProgress: updatedProgress);
  }

  Future<void> resetProgress() async {
    await StorageService.instance.resetOnboarding();
    await StorageService.instance.resetStationProgress();

    state = UserState.initial();
  }
}

class UserState {
  final bool isOnboardingComplete;
  final Map<String, dynamic> userProfile;
  final Map<int, String> stationProgress;

  UserState({required this.isOnboardingComplete, required this.userProfile, required this.stationProgress});

  factory UserState.initial() {
    return UserState(isOnboardingComplete: false, userProfile: {}, stationProgress: {});
  }

  UserState copyWith({bool? isOnboardingComplete, Map<String, dynamic>? userProfile, Map<int, String>? stationProgress}) {
    return UserState(
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      userProfile: userProfile ?? this.userProfile,
      stationProgress: stationProgress ?? this.stationProgress,
    );
  }
}

final userStateProvider = StateNotifierProvider<UserStateNotifier, UserState>((ref) {
  return UserStateNotifier();
});
