import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/screens/home_screens/bookmark_screen.dart';
import 'package:leftover_is_over_customer/screens/home_screens/home_screen.dart';
import 'package:leftover_is_over_customer/screens/home_screens/map_screen.dart';
import 'package:leftover_is_over_customer/screens/home_screens/my_order_screen.dart';
import 'package:leftover_is_over_customer/screens/home_screens/mypage_screen.dart';
import 'package:leftover_is_over_customer/services/auth_services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> screens;

  _MainScreenState()
      : screens = [
          HomeScreen(onProfileTap: () {}, onMapTap: () {}),
          const MapScreen(),
          const FavoriteScreen(),
          const MyOrderScreen(),
          const MyPageScreen(),
        ];

  @override
  void initState() {
    super.initState();
    // _MainScreenState 생성자에서 screens 초기화
    screens[0] = HomeScreen(
        onProfileTap: () => _changeTab(4), onMapTap: () => _changeTab(1));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: screenHeight * 0.1,
        backgroundColor: Theme.of(context).primaryColorLight,
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _navBarItems,
        indicatorColor: Theme.of(context).primaryColor,
      ),
    );
  }

  final List<Widget> _navBarItems = [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: '홈',
    ),
    const NavigationDestination(
      icon: Icon(Icons.map_outlined),
      selectedIcon: Icon(Icons.map_rounded),
      label: '지도',
    ),
    const NavigationDestination(
      icon: Icon(Icons.star_border),
      selectedIcon: Icon(Icons.star_border_rounded),
      label: '즐겨찾기',
    ),
    const NavigationDestination(
      icon: Icon(Icons.shopping_bag_outlined),
      selectedIcon: Icon(Icons.shopping_bag),
      label: '내 주문',
    ),
    const NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: '마이페이지',
    ),
  ];
}
