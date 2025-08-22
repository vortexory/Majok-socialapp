import 'package:flutter/material.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/screens/main_screen.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/providers/user_state_provider.dart';
import 'package:futu/src/providers/user_profile_provider.dart';
import 'package:futu/src/widgets/banner_ad_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This is the main screen that will host all the steps
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  // Controller to manage the pages
  final PageController _pageController = PageController();

  bool _isLastPage = false;

  // Store user data as they progress
  final Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      // Check if current page is the last one
      final isLast = _pageController.page?.round() == 6; // 6 is the index of the last page (GenderPage)
      if (isLast != _isLastPage) {
        setState(() {
          _isLastPage = isLast;
        });
      }
    });

    // Track onboarding start
    AnalyticsService.instance.logOnboardingStart();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateUserData(String key, dynamic value) {
    _userData[key] = value;
    print('Updated user data: $key = $value'); // Debug logging
    print('Current user data: $_userData'); // Debug logging
  }

  bool _isDataComplete() {
    // Check if all required fields are filled
    final requiredFields = ['name', 'age', 'height', 'weight', 'gender'];
    for (String field in requiredFields) {
      if (!_userData.containsKey(field) || _userData[field] == null) {
        print('Missing required field: $field'); // Debug logging
        return false;
      }
    }

    // Name should not be empty
    if (_userData['name']?.toString().trim().isEmpty ?? true) {
      print('Name is empty'); // Debug logging
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Define colors and styles once for consistency
    const primaryColor = Color(0xFF6A65F0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // The back arrow is handled automatically by Navigator
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black), // Make back arrow black
        title: Text(AppLocalizations.of(context)!.onboardingAppBarTitle, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Column(
        children: [
          // The PageView will take up most available space
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _NamePage(onDataChanged: _updateUserData),
                _AgePage(onDataChanged: _updateUserData),
                _HeightPage(onDataChanged: _updateUserData),
                _WeightPage(onDataChanged: _updateUserData),
                _HobbiesPage(onDataChanged: _updateUserData),
                _EducationPage(onDataChanged: _updateUserData),
                _GenderPage(onDataChanged: _updateUserData),
              ],
            ),
          ),

          // Bottom navigation area
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_isLastPage) {
                  // Check if all required data is complete
                  if (!_isDataComplete()) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all required fields before continuing.'), backgroundColor: Colors.red),
                    );
                    return;
                  }

                  // --- SOUND EFFECT UPDATED ---
                  AudioService.instance.play(Sound.generalReveal);

                  try {
                    // Process and clean user data before saving
                    final processedData = _processUserData(_userData);

                    // Save user data and complete onboarding
                    await ref.read(userStateProvider.notifier).completeOnboarding(processedData);

                    // Update the user profile provider with the new data
                    ref.read(userProfileProvider.notifier).updateFromOnboardingData(processedData);

                    // Track onboarding completion with user data
                    await AnalyticsService.instance.logOnboardingComplete();
                    await AnalyticsService.instance.logUserChoice(
                      choiceType: 'onboarding_complete',
                      choiceValue: 'success',
                      additionalData: {
                        'user_age': processedData['age'],
                        'user_gender': processedData['gender'],
                        'hobbies_count': (processedData['hobbies'] as List?)?.length ?? 0,
                      },
                    );

                    print('Onboarding completed successfully with data: $processedData'); // Debug logging

                    // Navigate to main screen
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const MainScreen()),
                        (route) => false, // This predicate removes all previous routes
                      );
                    }
                  } catch (e) {
                    print('Error completing onboarding: $e'); // Debug logging
                    // Show error message
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Something went wrong. Please try again.'), backgroundColor: Colors.red));
                    }
                  }
                } else {
                  // --- SOUND EFFECT UPDATED ---
                  AudioService.instance.play(Sound.transition);

                  // Track step completion
                  final currentStep = _pageController.page?.round() ?? 0;
                  await AnalyticsService.instance.logOnboardingStep(currentStep + 1);

                  // Otherwise, go to the next onboarding page
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 56), // Full width
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                // Change text based on whether it's the last page
                _isLastPage ? "Create My Profile!" : AppLocalizations.of(context)!.nextButton,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
          ),

          // --- ADDED BANNER AD ---
          const BannerAdWidget(placement: 'onboarding_bottom', margin: EdgeInsets.only(bottom: 8)),
        ],
      ),
    );
  }

  /// Process and clean user data before saving
  Map<String, dynamic> _processUserData(Map<String, dynamic> rawData) {
    final processed = <String, dynamic>{};

    // Process name
    processed['name'] = (rawData['name']?.toString() ?? '').trim();

    // Process age
    processed['age'] = rawData['age'] ?? 25;

    // Process height
    processed['height'] = rawData['height'] ?? 175;
    processed['height_unit'] = rawData['height_unit'] ?? 'HeightUnit.cm';

    // Process weight
    processed['weight'] = rawData['weight'] ?? 70;
    processed['weight_unit'] = rawData['weight_unit'] ?? 'WeightUnit.kg';

    // Process hobbies (ensure it's a list)
    final hobbies = rawData['hobbies'];
    if (hobbies is List) {
      processed['hobbies'] = hobbies;
    } else if (hobbies is Set) {
      processed['hobbies'] = hobbies.toList();
    } else {
      processed['hobbies'] = <String>[];
    }

    // Process education/career path
    processed['education'] = (rawData['education']?.toString() ?? '').trim();

    // Process gender
    final gender = rawData['gender']?.toString() ?? '';
    if (gender.contains('Gender.male')) {
      processed['gender'] = 'Male';
    } else if (gender.contains('Gender.female')) {
      processed['gender'] = 'Female';
    } else {
      processed['gender'] = gender.isEmpty ? 'Not specified' : gender;
    }

    // Add creation timestamp
    processed['created_at'] = DateTime.now().toIso8601String();
    processed['profile_version'] = 1;

    return processed;
  }
}

// A private widget for just the "Name" step to keep code organized.
class _NamePage extends StatefulWidget {
  final Function(String, dynamic) onDataChanged;

  const _NamePage({required this.onDataChanged});

  @override
  State<_NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<_NamePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      widget.onDataChanged('name', _nameController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Image.asset('assets/images/name_illustration.png', height: 150),
          const SizedBox(height: 50),
          Text(AppLocalizations.of(context)!.nameQuestion, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.nameHint,
              prefixIcon: Icon(Icons.label_outline, color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: const Color(0xFF6A65F0), width: 2),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // --- ADDED BANNER AD ---
          const BannerAdWidget(placement: 'onboarding_name', backgroundColor: Color(0xFFF8F9FA)),
        ],
      ),
    );
  }
}

class _AgePage extends StatefulWidget {
  final Function(String, dynamic) onDataChanged;

  const _AgePage({required this.onDataChanged});

  @override
  _AgePageState createState() => _AgePageState();
}

class _AgePageState extends State<_AgePage> {
  double _currentAge = 25.0;

  @override
  void initState() {
    super.initState();
    widget.onDataChanged('age', _currentAge.toInt());
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6A65F0);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: const Color(0xFFE8E7FD),
                  child: Image.asset('assets/images/age_illustration.png', fit: BoxFit.cover),
                ),
                const SizedBox(height: 24),
                Text(
                  _currentAge.toInt().toString(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
                ),
                const SizedBox(height: 16),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
                  ),
                  child: Slider(
                    value: _currentAge,
                    min: 18.0,
                    max: 99.0,
                    divisions: 99 - 18,
                    label: _currentAge.toInt().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentAge = value;
                      });
                      widget.onDataChanged('age', value.toInt());
                    },
                    activeColor: primaryColor,
                    inactiveColor: primaryColor.withOpacity(0.25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("18", style: Theme.of(context).textTheme.bodyMedium),
                      Text("99", style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(AppLocalizations.of(context)!.ageQuestion, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 30),
          // --- ADDED BANNER AD ---
          const BannerAdWidget(placement: 'onboarding_age', backgroundColor: Color(0xFFF8F9FA)),
        ],
      ),
    );
  }
}

enum HeightUnit { cm, inches }

class _HeightPage extends StatefulWidget {
  final Function(String, dynamic) onDataChanged;

  const _HeightPage({required this.onDataChanged});

  @override
  __HeightPageState createState() => __HeightPageState();
}

class __HeightPageState extends State<_HeightPage> {
  HeightUnit _selectedUnit = HeightUnit.cm;
  final TextEditingController _heightController = TextEditingController(text: "175");

  @override
  void initState() {
    super.initState();
    _heightController.addListener(() {
      final height = int.tryParse(_heightController.text) ?? 175;
      widget.onDataChanged('height', height);
      widget.onDataChanged('height_unit', _selectedUnit.toString());
    });
    // Initialize with default value
    widget.onDataChanged('height', 175);
    widget.onDataChanged('height_unit', _selectedUnit.toString());
  }

  @override
  void dispose() {
    _heightController.dispose();
    super.dispose();
  }

  void _onUnitChanged(HeightUnit newUnit) {
    if (_selectedUnit != newUnit) {
      AudioService.instance.play(Sound.tap);
      setState(() => _selectedUnit = newUnit);
      widget.onDataChanged('height_unit', newUnit.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.heightQuestion, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.heightCardTitle, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: TextField(
                        controller: _heightController,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildUnitToggle(context),
                  ],
                ),
                const SizedBox(height: 40),
                Image.asset('assets/images/height_illustration.png', height: 80),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // --- ADDED BANNER AD ---
          const BannerAdWidget(placement: 'onboarding_height', backgroundColor: Color(0xFFF8F9FA)),
        ],
      ),
    );
  }

  Widget _buildUnitToggle(BuildContext context) {
    const primaryColor = Color(0xFF6A65F0);

    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          _buildUnitButton(
            context: context,
            label: AppLocalizations.of(context)!.heightUnitCm,
            isSelected: _selectedUnit == HeightUnit.cm,
            onTap: () => _onUnitChanged(HeightUnit.cm),
            color: primaryColor,
          ),
          _buildUnitButton(
            context: context,
            label: AppLocalizations.of(context)!.heightUnitInches,
            isSelected: _selectedUnit == HeightUnit.inches,
            onTap: () => _onUnitChanged(HeightUnit.inches),
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildUnitButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)] : [],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? color : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

enum WeightUnit { kg, lbs }

class _WeightPage extends StatefulWidget {
  final Function(String, dynamic) onDataChanged;

  const _WeightPage({required this.onDataChanged});

  @override
  _WeightPageState createState() => _WeightPageState();
}

class _WeightPageState extends State<_WeightPage> {
  final TextEditingController _weightController = TextEditingController(text: "70");
  WeightUnit _selectedUnit = WeightUnit.kg;

  @override
  void initState() {
    super.initState();
    _weightController.addListener(() {
      final weight = int.tryParse(_weightController.text) ?? 70;
      widget.onDataChanged('weight', weight);
      widget.onDataChanged('weight_unit', _selectedUnit.toString());
      setState(() {}); // This forces a rebuild to update the large display text
    });
    // Initialize with default values
    widget.onDataChanged('weight', 70);
    widget.onDataChanged('weight_unit', _selectedUnit.toString());
  }

  void _onUnitChanged(WeightUnit newUnit) {
    if (_selectedUnit != newUnit) {
      AudioService.instance.play(Sound.tap);
      setState(() => _selectedUnit = newUnit);
      widget.onDataChanged('weight_unit', newUnit.toString());
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6A65F0);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context)!.weightQuestionTitle, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(AppLocalizations.of(context)!.weightQuestionSubtitle, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 24),
                    Image.asset('assets/images/weight_illustration.png', height: 120),
                    const SizedBox(height: 24),
                    // Large, dynamic weight display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _weightController.text.isEmpty ? "0" : _weightController.text,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            _selectedUnit == WeightUnit.kg
                                ? AppLocalizations.of(context)!.weightUnitKg
                                : AppLocalizations.of(context)!.weightUnitLbs,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Input field and unit toggle
                    _buildInputAndToggle(context, primaryColor),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // --- ADDED BANNER AD ---
              const BannerAdWidget(placement: 'onboarding_weight', backgroundColor: Color(0xFFF8F9FA)),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build the input field and unit toggle side-by-side
  Widget _buildInputAndToggle(BuildContext context, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _weightController,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 16)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  _buildUnitButton(
                    label: AppLocalizations.of(context)!.weightUnitKg,
                    isSelected: _selectedUnit == WeightUnit.kg,
                    onTap: () => _onUnitChanged(WeightUnit.kg),
                    color: primaryColor,
                  ),
                  _buildUnitButton(
                    label: AppLocalizations.of(context)!.weightUnitLbs,
                    isSelected: _selectedUnit == WeightUnit.lbs,
                    onTap: () => _onUnitChanged(WeightUnit.lbs),
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build each unit toggle button (kg, lbs)
  Widget _buildUnitButton({required String label, required bool isSelected, required VoidCallback onTap, required Color color}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: isSelected ? color : Colors.transparent, borderRadius: BorderRadius.circular(12)),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}

// 1. A simple data model for a hobby
class Hobby {
  final String id;
  final String iconPath;
  final String Function(AppLocalizations) getLabel;

  Hobby({required this.id, required this.iconPath, required this.getLabel});
}

// 2. The main page widget for selecting hobbies
class _HobbiesPage extends StatefulWidget {
  final Function(String, dynamic) onDataChanged;

  const _HobbiesPage({required this.onDataChanged});

  @override
  _HobbiesPageState createState() => _HobbiesPageState();
}

class _HobbiesPageState extends State<_HobbiesPage> {
  // A list of all available hobbies
  final List<Hobby> _allHobbies = [
    Hobby(id: 'music', iconPath: 'assets/images/music.png', getLabel: (l) => l.hobbyMusic),
    Hobby(id: 'reading', iconPath: 'assets/images/read.png', getLabel: (l) => l.hobbyReading),
    Hobby(id: 'gaming', iconPath: 'assets/images/game-console.png', getLabel: (l) => l.hobbyGaming),
    Hobby(id: 'fitness', iconPath: 'assets/images/weight.png', getLabel: (l) => l.hobbyFitness),
    Hobby(id: 'art', iconPath: 'assets/images/palette.png', getLabel: (l) => l.hobbyArt),
    Hobby(id: 'cooking', iconPath: 'assets/images/cooking.png', getLabel: (l) => l.hobbyCooking),
    Hobby(id: 'photography', iconPath: 'assets/images/photography.png', getLabel: (l) => l.hobbyPhotography),
    Hobby(id: 'travel', iconPath: 'assets/images/airplane.png', getLabel: (l) => l.hobbyTravel),
    Hobby(id: 'coffee', iconPath: 'assets/images/coffee-cup.png', getLabel: (l) => l.hobbyCoffee),
    Hobby(id: 'volunteering', iconPath: 'assets/images/volunteer.png', getLabel: (l) => l.hobbyVolunteering),
    Hobby(id: 'writing', iconPath: 'assets/images/content-writing.png', getLabel: (l) => l.hobbyWriting),
    Hobby(id: 'crafts', iconPath: 'assets/images/handcraft.png', getLabel: (l) => l.hobbyCrafts),
  ];

  // A set to store the IDs of the selected hobbies
  final Set<String> _selectedHobbies = {};

  @override
  void initState() {
    super.initState();
    // Initialize with empty list
    widget.onDataChanged('hobbies', _selectedHobbies.toList());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(localizations.hobbiesQuestion, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allHobbies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final hobby = _allHobbies[index];
                final isSelected = _selectedHobbies.contains(hobby.id);
                return _HobbyCard(
                  label: hobby.getLabel(localizations),
                  iconPath: hobby.iconPath,
                  isSelected: isSelected,
                  onTap: () {
                    AudioService.instance.play(Sound.tap);
                    setState(() {
                      if (isSelected) {
                        _selectedHobbies.remove(hobby.id);
                      } else {
                        _selectedHobbies.add(hobby.id);
                      }
                    });
                    widget.onDataChanged('hobbies', _selectedHobbies.toList());
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            // --- ADDED BANNER AD ---
            const BannerAdWidget(placement: 'onboarding_hobbies', backgroundColor: Color(0xFFF8F9FA)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// A helper widget for each selectable hobby card
class _HobbyCard extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _HobbyCard({required this.label, required this.iconPath, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6A65F0);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade200, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 40),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationPage extends StatefulWidget {
  final Function(String, dynamic) onDataChanged;

  const _EducationPage({required this.onDataChanged});

  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends State<_EducationPage> {
  late final TextEditingController _educationController;

  @override
  void initState() {
    super.initState();
    _educationController = TextEditingController();
    _educationController.addListener(() {
      setState(() {}); // To update the character count
      widget.onDataChanged('education', _educationController.text);
    });
    // Initialize with empty string
    widget.onDataChanged('education', '');
  }

  @override
  void dispose() {
    _educationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(localizations.pathQuestionTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(localizations.pathQuestionSubtitle, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 30),

          // Illustration
          CircleAvatar(
            radius: 70,
            backgroundColor: const Color(0xFFE8E7FD).withOpacity(0.5),
            child: Image.asset('assets/images/education_illustration.png', height: 140),
          ),
          const SizedBox(height: 40),

          // Input Card
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localizations.pathCardTitle, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),

              TextField(
                controller: _educationController,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                maxLength: 200,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: localizations.pathHint,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),

                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.work_outline, color: Colors.grey.shade400),
                  ),

                  counterText: "",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: const Color(0xFF6A65F0), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Character counter
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  localizations.pathCharacterCounter(_educationController.text.length.toString()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // --- ADDED BANNER AD ---
          const BannerAdWidget(placement: 'onboarding_education', backgroundColor: Color(0xFFF8F9FA)),
        ],
      ),
    );
  }
}

// 1. Enum for type-safety
enum Gender { male, female }

// 2. Data model to hold all info for a gender option
class GenderOption {
  final Gender id;
  final String iconPath;
  final String Function(AppLocalizations) getLabel;

  GenderOption({required this.id, required this.iconPath, required this.getLabel});
}

// 3. The main page widget for selecting gender
class _GenderPage extends StatefulWidget {
  final Function(String, dynamic) onDataChanged;

  const _GenderPage({required this.onDataChanged});

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<_GenderPage> {
  // List of all available gender options
  final List<GenderOption> _genderOptions = [
    GenderOption(id: Gender.male, iconPath: 'assets/images/male.png', getLabel: (l) => l.genderMale),
    GenderOption(id: Gender.female, iconPath: 'assets/images/female.png', getLabel: (l) => l.genderFemale),
  ];

  // Store the single selected gender. It's nullable for initial state.
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    // Initialize with null
    widget.onDataChanged('gender', null);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const titleText = "Select Your Gender";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(titleText, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 70,
            backgroundColor: const Color(0xFFFCE9F2),
            child: Image.asset('assets/images/gender_illustration.png', height: 90),
          ),
          const SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _genderOptions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final option = _genderOptions[index];
              final isSelected = _selectedGender == option.id;
              return _GenderCard(
                label: option.getLabel(localizations),
                iconPath: option.iconPath,
                isSelected: isSelected,
                onTap: () {
                  AudioService.instance.play(Sound.tap);
                  setState(() {
                    _selectedGender = option.id;
                  });
                  widget.onDataChanged('gender', option.id.toString());
                },
              );
            },
          ),
          const SizedBox(height: 30),
          // --- ADDED BANNER AD ---
          const BannerAdWidget(placement: 'onboarding_gender', backgroundColor: Color(0xFFF8F9FA)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Helper widget for the selectable gender card
class _GenderCard extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({required this.label, required this.iconPath, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Colors.pink.shade400;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? selectedColor : Colors.grey.shade200, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 40),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? selectedColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
