import 'package:flutter/material.dart';
import 'package:myapp/view/screens/about_screen.dart';
import 'package:myapp/view/screens/files_screen.dart';
import 'package:myapp/view/screens/home_screen.dart';
import 'package:myapp/view/screens/settings_screen.dart';
import 'package:myapp/view/screens/url_input_screen.dart';
import 'package:myapp/view/theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    FilesScreen(),
    SettingsScreen(),
    AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: AppTheme.surfaceDark,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(Icons.home, 0, 'Home'),
            _buildNavItem(Icons.folder, 1, 'Files'),
            const SizedBox(width: 48), // The gap for the FAB
            _buildNavItem(Icons.settings, 2, 'Settings'),
            _buildNavItem(Icons.info, 3, 'About'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UrlInputScreen()),
          );
        },
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: _selectedIndex == index ? AppTheme.primary : Colors.white),
          onPressed: () => _onItemTapped(index),
          tooltip: label,
        ),
      ],
    );
  }
}
