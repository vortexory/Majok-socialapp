import 'package:flutter/material.dart';
import 'package:futu/l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6A65F0);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.privacyPolicy, style: const TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with emoji
            Row(
              children: [
                const Text('📄', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.privacyPolicyTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Last Updated
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Icon(Icons.update, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.privacyPolicyLastUpdated,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Introduction
            Text(
              AppLocalizations.of(context)!.privacyPolicyIntro,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 24),

            // Policy Points
            _buildPolicyPoint(
              context,
              AppLocalizations.of(context)!.privacyPolicyWeDoNotCollect,
              AppLocalizations.of(context)!.privacyPolicyWeDoNotCollectDesc,
            ),

            _buildPolicyPoint(
              context,
              AppLocalizations.of(context)!.privacyPolicyUsageData,
              AppLocalizations.of(context)!.privacyPolicyUsageDataDesc,
            ),

            _buildPolicyPoint(context, AppLocalizations.of(context)!.privacyPolicyAds, AppLocalizations.of(context)!.privacyPolicyAdsDesc),

            _buildPolicyPoint(
              context,
              AppLocalizations.of(context)!.privacyPolicyContent,
              AppLocalizations.of(context)!.privacyPolicyContentDesc,
            ),

            _buildPolicyPoint(
              context,
              AppLocalizations.of(context)!.privacyPolicyDataStorage,
              AppLocalizations.of(context)!.privacyPolicyDataStorageDesc,
            ),

            _buildPolicyPoint(
              context,
              AppLocalizations.of(context)!.privacyPolicyChanges,
              AppLocalizations.of(context)!.privacyPolicyChangesDesc,
            ),

            const SizedBox(height: 24),

            // Contact Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.email, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.privacyPolicyContact,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'info@majokapp.com',
                          style: TextStyle(fontFamily: 'monospace', color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyPoint(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: Color(0xFF6A65F0), shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, color: Colors.grey.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
