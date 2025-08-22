import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/providers/user_profile_provider.dart';
import 'package:futu/src/providers/user_state_provider.dart';
import 'package:futu/src/screens/onboarding_screen.dart';
import 'package:futu/src/theme/app_theme.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/widgets/banner_ad_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final userProfile = ref.watch(userProfileProvider);
    final userState = ref.watch(userStateProvider);
    const accentColor = AppTheme.accentColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profileTitle, style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade50,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          const SizedBox(height: 30),

          // Profile Avatar and Name Section
          _buildProfileHeader(context, userProfile, accentColor),

          const SizedBox(height: 20),
          const Divider(indent: 20, endIndent: 20),
          const SizedBox(height: 20),

          // Banner Ad
          const BannerAdWidget(placement: 'profile_top', margin: EdgeInsets.only(bottom: 20)),

          // Profile Information Cards
          _buildProfileInfoSection(context, localizations, userProfile, userState),

          const SizedBox(height: 30),

          // Action Buttons Section
          _buildActionButtons(context, localizations, ref),

          const SizedBox(height: 20),

          // Bottom Banner Ad
          const BannerAdWidget(placement: 'profile_bottom', margin: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, userProfile, Color accentColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: accentColor.withOpacity(0.2),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: accentColor,
            child: Text(userProfile.initials, style: AppTheme.resultTextStyle.copyWith(color: Colors.white, fontSize: 40)),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          userProfile.name.isNotEmpty ? userProfile.name : 'Welcome User',
          style: AppTheme.resultTextStyle.copyWith(color: Colors.black87, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
          child: Text(
            'Profile Complete ✨',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoSection(BuildContext context, AppLocalizations localizations, userProfile, UserState userState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.profileInfoSection ?? 'Your Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 16),

        // Basic Info Cards
        _ProfileInfoCard(
          iconPath: 'assets/images/icon_baby.png',
          label: localizations.profileAge,
          value: "${userProfile.age} ${localizations.profileYears}",
          valueColor: AppTheme.primaryColor,
        ),
        _ProfileInfoCard(
          iconPath: 'assets/images/icon_height.png',
          label: localizations.profileHeight,
          value: "${userProfile.height} cm",
          valueColor: AppTheme.primaryColor,
        ),
        _ProfileInfoCard(
          iconPath: 'assets/images/gender.png',
          label: localizations.profileGender,
          value: userProfile.gender,
          valueColor: AppTheme.primaryColor,
        ),

        // Hobbies Card (Special handling for lists)
        _ProfileHobbiesCard(iconPath: 'assets/images/icon_hobbies.png', label: localizations.profileHobbies, hobbies: userProfile.hobbies),

        // Progress Summary Card
        const SizedBox(height: 20),
        _buildProgressSummaryCard(context, localizations, userState),
      ],
    );
  }

  Widget _buildProgressSummaryCard(BuildContext context, AppLocalizations localizations, UserState userState) {
    final completedStations = userState.stationProgress.values.where((status) => status == 'completed').length;
    final totalStations = 5;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                'Journey Progress',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$completedStations of $totalStations stations completed',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: completedStations / totalStations,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations localizations, WidgetRef ref) {
    return Column(
      children: [
        Text(
          'Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 16),

        // Restart Journey Button
        _ActionButton(
          icon: Icons.refresh,
          label: localizations.retryButton,
          subtitle: 'Start your journey from the beginning',
          color: AppTheme.accentColor,
          onTap: () => _showRestartConfirmation(context, localizations, ref),
        ),

        const SizedBox(height: 12),

        // Edit Profile Button (for future use)
        _ActionButton(
          icon: Icons.edit,
          label: 'Edit Profile',
          subtitle: 'Update your personal information',
          color: AppTheme.primaryColor,
          onTap: () => _editProfile(context, ref),
        ),
      ],
    );
  }

  void _showRestartConfirmation(BuildContext context, AppLocalizations localizations, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restart Journey?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          content: Text(
            'This will delete all your progress and take you back to the beginning. Are you sure?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                AudioService.instance.play(Sound.tap);
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              onPressed: () async {
                AudioService.instance.play(Sound.generalReveal);
                Navigator.of(context).pop();
                await _restartJourney(context, ref);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor, foregroundColor: Colors.white),
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _restartJourney(BuildContext context, WidgetRef ref) async {
    try {
      // Track analytics
      await AnalyticsService.instance.logUserChoice(choiceType: 'profile_action', choiceValue: 'restart_journey');

      // Reset user state and progress
      await ref.read(userStateProvider.notifier).resetProgress();

      // Clear user profile
      ref.read(userProfileProvider.notifier).clearProfile();

      // Navigate to onboarding
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const OnboardingScreen()), (route) => false);
      }
    } catch (e) {
      print('Error restarting journey: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Something went wrong. Please try again.'), backgroundColor: Colors.red));
      }
    }
  }

  void _editProfile(BuildContext context, WidgetRef ref) {
    AudioService.instance.play(Sound.tap);

    // Track analytics
    AnalyticsService.instance.logUserChoice(choiceType: 'profile_action', choiceValue: 'edit_profile');

    // Navigate to onboarding in edit mode
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OnboardingScreen()));
  }
}

// Enhanced Profile Info Card
class _ProfileInfoCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  final Color? valueColor;

  const _ProfileInfoCard({required this.iconPath, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (valueColor ?? AppTheme.primaryColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(iconPath, height: 24, width: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'Not specified',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: valueColor ?? Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Special card for hobbies with chips
class _ProfileHobbiesCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final List<String> hobbies;

  const _ProfileHobbiesCard({required this.iconPath, required this.label, required this.hobbies});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Image.asset(iconPath, height: 24, width: 24),
              ),
              const SizedBox(width: 16),
              Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 12),
          if (hobbies.isEmpty)
            Text(
              'No hobbies selected',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500, fontStyle: FontStyle.italic),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: hobbies.map((hobby) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    hobby,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

// Action Button Widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AudioService.instance.play(Sound.tap);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }
}
