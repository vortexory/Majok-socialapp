import 'package:flutter/material.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/screens/station_1/station_1_puzzle_screen.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';

// Enum to represent the different destiny cards
enum Destiny { sage, voyager, guardian }

class Station1CardSelectionScreen extends StatefulWidget {
  const Station1CardSelectionScreen({Key? key}) : super(key: key);

  @override
  _Station1CardSelectionScreenState createState() => _Station1CardSelectionScreenState();
}

class _Station1CardSelectionScreenState extends State<Station1CardSelectionScreen> {
  Destiny? _selectedDestiny;

  static const Color mainBlue = Color(0xFF6A65F0);

  @override
  void initState() {
    super.initState();
    // Track station start
    AnalyticsService.instance.logStationStart(1, 'Partner Traits Discovery');
  }

  void _selectDestiny(Destiny destiny) {
    if (_selectedDestiny != destiny) {
      AudioService.instance.play(Sound.tap);
      setState(() => _selectedDestiny = destiny);

      // Track user choice
      AnalyticsService.instance.logUserChoice(choiceType: 'destiny_selection', choiceValue: destiny.toString(), stationId: 1);
    }
  }

  String _getDestinyString(Destiny destiny) {
    switch (destiny) {
      case Destiny.sage:
        return 'sage';
      case Destiny.voyager:
        return 'voyager';
      case Destiny.guardian:
        return 'guardian';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.station1ScreenTitle, style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            // Heading
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 4),
                child: Text(
                  localizations.chooseYourDestiny,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: mainBlue, fontSize: 28),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Destiny Cards
            _DestinyCard(
              iconPath: 'assets/images/icon_mystic_sage.png',
              title: localizations.destinyCard1Title,
              description: localizations.destinyCard1Desc,
              isSelected: _selectedDestiny == Destiny.sage,
              onTap: () => _selectDestiny(Destiny.sage),
              mainBlue: mainBlue,
            ),
            const SizedBox(height: 16),
            _DestinyCard(
              iconPath: 'assets/images/icon_swift_voyager.png',
              title: localizations.destinyCard2Title,
              description: localizations.destinyCard2Desc,
              isSelected: _selectedDestiny == Destiny.voyager,
              onTap: () => _selectDestiny(Destiny.voyager),
              mainBlue: mainBlue,
            ),
            const SizedBox(height: 16),
            _DestinyCard(
              iconPath: 'assets/images/icon_iron_guardian.png',
              title: localizations.destinyCard3Title,
              description: localizations.destinyCard3Desc,
              isSelected: _selectedDestiny == Destiny.guardian,
              onTap: () => _selectDestiny(Destiny.guardian),
              mainBlue: mainBlue,
            ),

            const SizedBox(height: 48),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedDestiny == null
                    ? null
                    : () {
                        AudioService.instance.play(Sound.transition);

                        // Pass the selected destiny to the puzzle screen
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => Station1PuzzleScreen(selectedDestiny: _getDestinyString(_selectedDestiny!))),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text(
                  AppLocalizations.of(context)!.nextButton,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Keep the existing _DestinyCard widget exactly the same
class _DestinyCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  final Color mainBlue;

  const _DestinyCard({
    required this.iconPath,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    required this.mainBlue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? mainBlue : Colors.grey.shade200, width: 2.5),
          boxShadow: isSelected
              ? [BoxShadow(color: mainBlue.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)]
              : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Image.asset(iconPath, height: 60),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17, color: mainBlue, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13, height: 1.3),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
