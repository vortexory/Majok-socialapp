import 'package:flutter/material.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/screens/station_2/station_2_result_screen.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';

class Station2OnboardingScreen extends StatefulWidget {
  const Station2OnboardingScreen({super.key});
  @override
  _Station2OnboardingScreenState createState() => _Station2OnboardingScreenState();
}

class _Station2OnboardingScreenState extends State<Station2OnboardingScreen> {
  final PageController _pageController = PageController();
  bool _isLastPage = false;

  // Data collection variables
  String? _selectedZodiac;
  String? _selectedAnimal = 'cat'; // Pre-select as per design
  String? _selectedRide = 'air_balloon'; // Pre-select as per design
  final TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Track station start
    AnalyticsService.instance.logStationStart(2, 'Love Story Creation');

    // Add a listener to update the button text
    _pageController.addListener(() {
      final isLast = (_pageController.page?.round() ?? 0) == 1; // 0=Zodiac, 1=Preferences
      if (isLast != _isLastPage) {
        setState(() {
          _isLastPage = isLast;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _updateZodiac(String? zodiac) {
    setState(() {
      _selectedZodiac = zodiac;
    });

    if (zodiac != null) {
      AnalyticsService.instance.logUserChoice(choiceType: 'zodiac_selection', choiceValue: zodiac, stationId: 2);
    }
  }

  void _updateAnimal(String animal) {
    setState(() {
      _selectedAnimal = animal;
    });

    AnalyticsService.instance.logUserChoice(choiceType: 'spirit_animal_selection', choiceValue: animal, stationId: 2);
  }

  void _updateRide(String ride) {
    setState(() {
      _selectedRide = ride;
    });

    AnalyticsService.instance.logUserChoice(choiceType: 'dream_ride_selection', choiceValue: ride, stationId: 2);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF6A65F0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(localizations.station2AppBarTitle, style: Theme.of(context).textTheme.headlineMedium),
      ),
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swiping
        children: [
          _ZodiacPage(selectedZodiac: _selectedZodiac, onZodiacChanged: _updateZodiac),
          _PreferencesPage(
            destinationController: _destinationController,
            selectedAnimal: _selectedAnimal,
            selectedRide: _selectedRide,
            onAnimalChanged: _updateAnimal,
            onRideChanged: _updateRide,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_isLastPage) {
                  AudioService.instance.play(Sound.generalReveal);

                  // Pass all collected data to result screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Station2ResultScreen(
                        selectedZodiac: _selectedZodiac,
                        selectedAnimal: _selectedAnimal ?? 'cat',
                        selectedRide: _selectedRide ?? 'air_balloon',
                        dreamDestination: _destinationController.text.trim(),
                      ),
                    ),
                  );
                } else {
                  AudioService.instance.play(Sound.transition);
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                _isLastPage ? localizations.seeYourStoryButton ?? "See Your Story!" : localizations.nextStepButton,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
            if (!_isLastPage) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  AudioService.instance.play(Sound.transition);
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
                child: Text(
                  localizations.skipForNowButton,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Updated _ZodiacPage to accept callbacks
class _ZodiacPage extends StatefulWidget {
  final String? selectedZodiac;
  final ValueChanged<String?> onZodiacChanged;

  const _ZodiacPage({required this.selectedZodiac, required this.onZodiacChanged});

  @override
  _ZodiacPageState createState() => _ZodiacPageState();
}

class _ZodiacPageState extends State<_ZodiacPage> {
  late final List<Map<String, dynamic>> _zodiacOptions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = AppLocalizations.of(context)!;
    _zodiacOptions = [
      {'id': 'aries', 'icon': 'assets/images/aries.png', 'label': localizations.zodiacAries},
      {'id': 'taurus', 'icon': 'assets/images/taurus.png', 'label': localizations.zodiacTaurus},
      {'id': 'gemini', 'icon': 'assets/images/gemini.png', 'label': localizations.zodiacGemini},
      {'id': 'cancer', 'icon': 'assets/images/cancer.png', 'label': localizations.zodiacCancer},
      {'id': 'leo', 'icon': 'assets/images/leo.png', 'label': localizations.zodiacLeo},
      {'id': 'virgo', 'icon': 'assets/images/virgo.png', 'label': localizations.zodiacVirgo},
      {'id': 'libra', 'icon': 'assets/images/libra.png', 'label': localizations.zodiacLibra},
      {'id': 'scorpio', 'icon': 'assets/images/scorpio.png', 'label': localizations.zodiacScorpio},
      {'id': 'sagittarius', 'icon': 'assets/images/sagittarius.png', 'label': localizations.zodiacSagittarius},
      {'id': 'capricorn', 'icon': 'assets/images/capricorn.png', 'label': localizations.zodiacCapricorn},
      {'id': 'aquarius', 'icon': 'assets/images/aquarius.png', 'label': localizations.zodiacAquarius},
      {'id': 'pisces', 'icon': 'assets/images/pisces.png', 'label': localizations.zodiacPisces},
    ];
  }

  void _onSignSelected(String signId) {
    if (widget.selectedZodiac != signId) {
      AudioService.instance.play(Sound.tap);
      widget.onZodiacChanged(signId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/images/zodiac_hero.png', height: 180, fit: BoxFit.cover),
          ),
          const SizedBox(height: 24),
          Text(AppLocalizations.of(context)!.zodiacQuestion, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _zodiacOptions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.25,
            ),
            itemBuilder: (context, index) {
              final option = _zodiacOptions[index];
              final isSelected = widget.selectedZodiac == option['id'];
              return _ZodiacCard(
                iconPath: option['icon'],
                label: option['label'],
                isSelected: isSelected,
                onTap: () => _onSignSelected(option['id']),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Keep the existing _ZodiacCard widget exactly the same
class _ZodiacCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ZodiacCard({required this.iconPath, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF6A65F0);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 40),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem {
  final String id;
  final String iconPath;
  final String Function(AppLocalizations) getLabel;
  GridItem({required this.id, required this.iconPath, required this.getLabel});
}

// Updated _PreferencesPage to accept callbacks
class _PreferencesPage extends StatefulWidget {
  final TextEditingController destinationController;
  final String? selectedAnimal;
  final String? selectedRide;
  final ValueChanged<String> onAnimalChanged;
  final ValueChanged<String> onRideChanged;

  const _PreferencesPage({
    required this.destinationController,
    required this.selectedAnimal,
    required this.selectedRide,
    required this.onAnimalChanged,
    required this.onRideChanged,
  });

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<_PreferencesPage> {
  late final List<GridItem> _animalOptions;
  late final List<GridItem> _rideOptions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animalOptions = [
      GridItem(id: 'cow', iconPath: 'assets/images/cow.png', getLabel: (l) => l.animalBrain),
      GridItem(id: 'cat', iconPath: 'assets/images/in-love.png', getLabel: (l) => l.animalCat),
      GridItem(id: 'dog', iconPath: 'assets/images/corgi.png', getLabel: (l) => l.animalDog),
      GridItem(id: 'globe', iconPath: 'assets/images/planet.png', getLabel: (l) => l.animalGlobe),
      GridItem(id: 'xmark', iconPath: 'assets/images/bird.png', getLabel: (l) => l.animalXMark),
      GridItem(id: 'rabbit', iconPath: 'assets/images/vegetable.png', getLabel: (l) => l.animalRabbit),
    ];
    _rideOptions = [
      GridItem(id: 'air_balloon', iconPath: 'assets/images/hot-air-balloon.png', getLabel: (l) => l.rideAirBalloon),
      GridItem(id: 'race_car', iconPath: 'assets/images/car.png', getLabel: (l) => l.rideRaceCar),
      GridItem(id: 'motorcycle', iconPath: 'assets/images/motorcycle.png', getLabel: (l) => l.rideMotorcycle),
      GridItem(id: 'bicycle', iconPath: 'assets/images/bike.png', getLabel: (l) => l.rideBicycle),
      GridItem(id: 'bus', iconPath: 'assets/images/bus.png', getLabel: (l) => l.rideBus),
      GridItem(id: 'truck_van', iconPath: 'assets/images/shipping.png', getLabel: (l) => l.rideTruckVan),
    ];
  }

  void _onAnimalSelected(String id) {
    if (widget.selectedAnimal != id) {
      AudioService.instance.play(Sound.tap);
      widget.onAnimalChanged(id);
    }
  }

  void _onRideSelected(String id) {
    if (widget.selectedRide != id) {
      AudioService.instance.play(Sound.tap);
      widget.onRideChanged(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              Image.asset('assets/images/station_2_hero.png', height: 200, width: double.infinity, fit: BoxFit.fitHeight),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.station2HeroTitle, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(localizations.station2HeroSubtitle, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    Text(localizations.destinationQuestion, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    TextField(
                      controller: widget.destinationController,
                      decoration: InputDecoration(
                        hintText: localizations.destinationHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            backgroundColor: const Color(0xFF6A65F0),
                            child: const Icon(Icons.airplanemode_active, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _SelectionGrid(
                      title: localizations.spiritAnimalQuestion,
                      items: _animalOptions,
                      selectedId: widget.selectedAnimal,
                      onItemSelected: _onAnimalSelected,
                    ),
                    const SizedBox(height: 24),
                    _SelectionGrid(
                      title: localizations.dreamRideQuestion,
                      items: _rideOptions,
                      selectedId: widget.selectedRide,
                      onItemSelected: _onRideSelected,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Keep the existing _SelectionGrid and _GridItemCard widgets exactly the same
class _SelectionGrid extends StatelessWidget {
  final String title;
  final List<GridItem> items;
  final String? selectedId;
  final ValueChanged<String> onItemSelected;

  const _SelectionGrid({required this.title, required this.items, this.selectedId, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = selectedId == item.id;
            return _GridItemCard(
              iconPath: item.iconPath,
              label: item.getLabel(AppLocalizations.of(context)!),
              isSelected: isSelected,
              onTap: () => onItemSelected(item.id),
            );
          },
        ),
      ],
    );
  }
}

class _GridItemCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GridItemCard({required this.iconPath, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF6A65F0);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(flex: 2, child: Image.asset(iconPath, height: 48)),
                const SizedBox(height: 12),
                Flexible(
                  flex: 1,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: isSelected ? color : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: color,
                child: const Icon(Icons.check, color: Colors.white, size: 12),
              ),
            ),
        ],
      ),
    );
  }
}
