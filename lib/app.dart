import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/metro_map_screen.dart';
import 'screens/station_info_screen.dart';
import 'widgets/bottom_nav_bar.dart';

class MetroNavigatorApp extends StatefulWidget {
  const MetroNavigatorApp({super.key});

  @override
  State<MetroNavigatorApp> createState() => _MetroNavigatorAppState();
}

class _MetroNavigatorAppState extends State<MetroNavigatorApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    MetroMapScreen(),
    StationInfoScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
