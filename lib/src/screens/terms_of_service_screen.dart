import 'package:flutter/material.dart';
import 'package:futu/l10n/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6A65F0);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.termsOfService, style: const TextStyle(color: Colors.white)),
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
                const Text('📜', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.termsOfServiceTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Introduction
            Text(
              AppLocalizations.of(context)!.termsOfServiceIntro,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 24),

            // Terms Points
            _buildTermsPoint(context, AppLocalizations.of(context)!.termsOfServiceEntertainment),

            _buildTermsPoint(context, AppLocalizations.of(context)!.termsOfServiceAgeRequirement),

            _buildTermsPoint(context, AppLocalizations.of(context)!.termsOfServiceFictionalContent),

            _buildTermsPoint(context, AppLocalizations.of(context)!.termsOfServiceSharing),

            _buildTermsPoint(context, AppLocalizations.of(context)!.termsOfServiceAds),

            _buildTermsPoint(context, AppLocalizations.of(context)!.termsOfServiceCopyright),

            _buildTermsPoint(context, AppLocalizations.of(context)!.termsOfServiceDisclaimer),

            const SizedBox(height: 24),

            // Bottom Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.termsOfServiceImportantNotice,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.4, color: Colors.orange.shade800, fontWeight: FontWeight.w500),
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

  Widget _buildTermsPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }
}
