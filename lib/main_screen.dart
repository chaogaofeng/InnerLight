import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/practice/presentation/pages/practice_page.dart';
import 'features/ceremony/presentation/pages/ceremony_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/reading/presentation/pages/read_library_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ReadLibraryPage(),
    const PracticePage(),
    const CeremonyPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF8), // zen-bg
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFDFCF8).withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, '首页', Icons.home),
                _buildNavItem(1, '阅读', Icons.menu_book),
                _buildNavItem(2, '修行', Icons.filter_vintage),
                _buildNavItem(3, '佛事', Icons.notifications_active), // Bell
                _buildNavItem(4, '我的', Icons.person),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final isSelected = _selectedIndex == index;
    final color = isSelected
        ? const Color(0xFF8B5A2B)
        : const Color(
            0xFF8B5A2B,
          ).withValues(alpha: 0.4); // zen-brown vs subtitle

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(icon, color: color, size: 24),
              ),
              if (index == 3 &&
                  !isSelected) // Badge logic placeholder for 'Events'
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.red[800],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
              color: color,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
