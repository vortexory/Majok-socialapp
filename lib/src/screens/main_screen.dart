import 'package:flutter/material.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/screens/dashboard_screen.dart';
import 'package:futu/src/screens/profile_screen.dart';
import 'package:futu/src/screens/progress_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // 0 for Home, 1 for Progress, 2 for Profile

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF6A65F0);

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              activeColor: Colors.white,
              tabBackgroundColor: primaryColor,
              color: Colors.black54,
              gap: 8,
              padding: const EdgeInsets.all(16),
              duration: const Duration(milliseconds: 400),
              onTabChange: _onItemTapped,
              selectedIndex: _selectedIndex,
              tabs: [
                GButton(
                  icon: Icons.circle, // provide a dummy icon
                  leading: Image.asset(
                    'assets/images/dash.png', // your colored PNG
                    width: 24,
                    height: 24,
                  ),
                  text: localizations.navHome,
                ),
                GButton(
                  icon: Icons.circle,
                  leading: Image.asset(
                    'assets/images/check.png',
                    width: 24,
                    height: 24,
                  ),
                  text: localizations.navProgress,
                ),
                GButton(
                  icon: Icons.circle,
                  leading: Image.asset(
                    'assets/images/profile.png',
                    width: 24,
                    height: 24,
                  ),
                  text: localizations.navProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}