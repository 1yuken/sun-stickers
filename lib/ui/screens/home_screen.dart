import 'package:flutter/material.dart';

import '../../data/_data.dart';
import '../_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens = [
    const StickerList(),
    const CartScreen(),
    const FavoriteScreen(),
    const ProfileScreen()
  ];
  int currentIndex = 0;

  void onTabTap(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTap,
        selectedFontSize: 0,
        items: AppData.bottomNavigationItems.map(
          (element) {
            return BottomNavigationBarItem(
              icon: KeyedSubtree(
                  key: ValueKey(
                      'nav-${AppData.bottomNavigationItems.indexOf(element)}'),
                  child: element.disableIcon),
              label: element.label,
              activeIcon: KeyedSubtree(
                  key: ValueKey(
                      'active-nav-${AppData.bottomNavigationItems.indexOf(element)}'),
                  child: element.enableIcon),
            );
          },
        ).toList(),
      ),
    );
  }
}
