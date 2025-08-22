import 'package:flutter/material.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/screens/station_4/station_4_result_screen.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';

class Station4PreferencesScreen extends StatefulWidget {
  const Station4PreferencesScreen({Key? key}) : super(key: key);
  @override
  _Station4PreferencesScreenState createState() => _Station4PreferencesScreenState();
}

class _Station4PreferencesScreenState extends State<Station4PreferencesScreen> {
  int? _selectedColorIndex;
  String? _selectedFruitId;
  final TextEditingController _celebrityScoopController = TextEditingController();
  final TextEditingController _movieMagicController = TextEditingController();

  final List<Color> _colorOptions = const [
    Colors.yellow,
    Colors.orange,
    Colors.pink,
    Colors.blue,
    Colors.lightBlue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.lightGreen,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.grey,
    Colors.redAccent,
  ];

  late final List<Map<String, String>> _fruitOptions;

  @override
  void initState() {
    super.initState();
    // Track station start
    AnalyticsService.instance.logStationStart(4, 'Chat with Soulmate');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = AppLocalizations.of(context)!;
    _fruitOptions = [
      {'id': 'apple', 'icon': 'assets/images/icon_apple.png', 'label': localizations.fruitApple},
      {'id': 'banana', 'icon': 'assets/images/icon_banana.png', 'label': localizations.fruitBanana},
      {'id': 'citrus', 'icon': 'assets/images/icon_citrus.png', 'label': localizations.fruitCitrus},
      {'id': 'grape', 'icon': 'assets/images/icon_grape.png', 'label': 'Grape'},
      {'id': 'cherry', 'icon': 'assets/images/icon_cherry.png', 'label': localizations.fruitCherry},
      {'id': 'mango', 'icon': 'assets/images/icon_mango.png', 'label': 'Mango'},
      {'id': 'avocado', 'icon': 'assets/images/icon_avocado.png', 'label': 'Cherry'},
      {'id': 'pear', 'icon': 'assets/images/icon_pear.png', 'label': localizations.fruitPear},
    ];
  }

  @override
  void dispose() {
    _celebrityScoopController.dispose();
    _movieMagicController.dispose();
    super.dispose();
  }

  void _onColorSelected(int index) {
    if (_selectedColorIndex != index) {
      AudioService.instance.play(Sound.tap);
      setState(() => _selectedColorIndex = index);
      
      // Track user choice
      AnalyticsService.instance.logUserChoice(
        choiceType: 'color_selection', 
        choiceValue: index.toString(), 
        stationId: 4
      );
    }
  }

  void _onFruitSelected(String id) {
    if (_selectedFruitId != id) {
      AudioService.instance.play(Sound.tap);
      setState(() => _selectedFruitId = id);
      
      // Track user choice
      AnalyticsService.instance.logUserChoice(
        choiceType: 'fruit_selection', 
        choiceValue: id, 
        stationId: 4
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF6A65F0);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: Text("Tell Us About You!", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionCard(
            context: context,
            icon: Icons.star_border,
            iconColor: Colors.orange,
            title: localizations.celebScoopTitle,
            subtitle: localizations.celebScoopSubtitle,
            child: TextField(
              controller: _celebrityScoopController,
              decoration: InputDecoration(
                hintText: localizations.celebScoopHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          _buildSectionCard(
            context: context,
            icon: Icons.color_lens_outlined,
            iconColor: Colors.orange,
            title: localizations.colorVibesTitle,
            subtitle: localizations.colorVibesSubtitle,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _colorOptions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                final isSelected = _selectedColorIndex == index;
                return GestureDetector(
                  onTap: () => _onColorSelected(index),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _colorOptions[index],
                      border: Border.all(color: isSelected ? primaryColor : Colors.black, width: 3),
                    ),
                    child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                  ),
                );
              },
            ),
          ),
          _buildSectionCard(
            context: context,
            icon: Icons.emoji_food_beverage_outlined,
            iconColor: Colors.orange,
            title: localizations.fruityFavoritesTitle,
            subtitle: localizations.fruityFavoritesSubtitle,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _fruitOptions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final option = _fruitOptions[index];
                final isSelected = _selectedFruitId == option['id'];
                return GestureDetector(
                  onTap: () => _onFruitSelected(option['id']!),
                  child: Column(
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? Colors.orange : Colors.grey.shade200, width: 2),
                          ),
                          child: Center(child: Image.asset(option['icon']!, height: 32)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option['label']!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.orange : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildSectionCard(
            context: context,
            icon: Icons.movie_filter_outlined,
            iconColor: Colors.orange,
            title: localizations.movieMagicTitle,
            subtitle: localizations.movieMagicSubtitle,
            child: TextField(
              controller: _movieMagicController,
              decoration: InputDecoration(
                hintText: localizations.movieMagicHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            AudioService.instance.play(Sound.transition);
            
            // Pass all collected data to the result screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => Station4ResultScreen(
                  celebrityScoop: _celebrityScoopController.text.trim(),
                  selectedColorIndex: _selectedColorIndex,
                  selectedFruit: _selectedFruitId,
                  movieMagic: _movieMagicController.text.trim(),
                ),
              ),
            );
          },
          icon: const Icon(Icons.favorite, color: Colors.white),
          label: Text(localizations.savePreferencesButton, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(subtitle, style: Theme.of(context).textTheme.titleSmall),
          ),
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.only(left: 32.0), child: child),
        ],
      ),
    );
  }
}