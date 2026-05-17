import 'package:flutter/material.dart';
import 'core/theme/app_text_styles.dart';

// Screens
import 'home_screen.dart';
import 'wisata_screen.dart';
import 'quiz_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  // Global notifier — siapa saja bisa switch tab dari mana saja
  static final tabNotifier = ValueNotifier<int>(0);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WisataScreen(),
    const QuizScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    MainWrapper.tabNotifier.addListener(_onTabChange);
  }

  @override
  void dispose() {
    MainWrapper.tabNotifier.removeListener(_onTabChange);
    super.dispose();
  }

  void _onTabChange() {
    setState(() {
      _currentIndex = MainWrapper.tabNotifier.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          // Tampilan Desktop dengan NavigationRail
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (int index) {
                    MainWrapper.tabNotifier.value = index;
                  },
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(color: Color(0xFF1D4ED8)),
                  selectedLabelTextStyle: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF1D4ED8),
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedIconTheme: const IconThemeData(color: Color(0xFF94A3B8)),
                  unselectedLabelTextStyle: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home_filled), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.explore), label: Text('Wisata')),
                    NavigationRailDestination(icon: Icon(Icons.quiz), label: Text('Kuis')),
                    NavigationRailDestination(icon: Icon(Icons.chat_bubble), label: Text('Chat AI')),
                    NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profil')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: IndexedStack(index: _currentIndex, children: _screens),
                ),
              ],
            ),
          );
        }

        // Tampilan Mobile dengan BottomNavigationBar
        return Scaffold(
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(
              top: 12,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x140056B3),
                  blurRadius: 12,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, 'Home', Icons.home_filled),
                _buildNavItem(1, 'Wisata', Icons.explore),
                _buildNavItem(2, 'Kuis', Icons.quiz),
                _buildNavItem(3, 'Chat AI', Icons.chat_bubble),
                _buildNavItem(4, 'Profil', Icons.person),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        MainWrapper.tabNotifier.value = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEFF6FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive
                  ? const Color(0xFF1D4ED8)
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isActive
                    ? const Color(0xFF1D4ED8)
                    : const Color(0xFF94A3B8),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
