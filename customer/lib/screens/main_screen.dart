import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/screens/home_screen.dart';
import 'package:leftover_is_over_customer/screens/map_screen.dart';
import 'package:leftover_is_over_customer/screens/my_order_screen.dart';
import 'package:leftover_is_over_customer/screens/mypage_screen.dart';
import 'package:leftover_is_over_customer/screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> screens = <Widget>[
    const HomeScreen(),
    const MapScreen(),
    const SearchScreen(),
    const MyOrderScreen(),
    const MyPageScreen(),
  ];

  void onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: screens[_selectedIndex],
        bottomNavigationBar: NavigationBar(
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
        ));
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
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search_rounded),
      label: '검색',
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