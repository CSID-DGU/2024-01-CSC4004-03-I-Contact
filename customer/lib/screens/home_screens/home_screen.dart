import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_customer/screens/search_screens/category_search_screen.dart';
import 'package:leftover_is_over_customer/screens/home_screens/main_screen.dart';
import 'package:leftover_is_over_customer/screens/home_screens/map_screen.dart';
import 'package:leftover_is_over_customer/screens/search_screens/notifications_screen.dart';
import 'package:leftover_is_over_customer/screens/search_screens/search_screen.dart';

import '../../widgets/food_category_widget.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onMapTap;

  const HomeScreen(
      {super.key, required this.onProfileTap, required this.onMapTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        margin: EdgeInsets.only(
            top: screenHeight * 0.025,
            left: screenHeight * 0.025,
            right: screenHeight * 0.025),
        child: Column(
          children: [
            SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.1,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onProfileTap,
                    child: Container(
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
                      margin: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                            width: 2),
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.person_2_rounded,
                        size: screenWidth * 0.1,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.1,
                    margin: EdgeInsets.all(screenWidth * 0.02),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(45)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '아이디123',
                        style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.1,
                      height: screenHeight * 0.1,
                      margin: EdgeInsets.only(left: screenWidth * 0.1),
                      child: Icon(
                        Icons.notifications,
                        size: 32,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.06,
                margin: const EdgeInsets.only(
                    top: 5, bottom: 20, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 2.0,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.all(7)),
                      Icon(
                        Icons.search,
                        size: 32,
                        color: Colors.black38,
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(
                        '검색',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black38),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.22,
              margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 2.0,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '    카테고리',
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.03,
                        ),
                        const FoodCategoryWidget(
                            categoryNumber: 1, foodName: '한식'),
                        const FoodCategoryWidget(
                            categoryNumber: 2, foodName: '중식'),
                        const FoodCategoryWidget(
                            categoryNumber: 3, foodName: '일식'),
                        const FoodCategoryWidget(
                            categoryNumber: 4, foodName: '양식'),
                        const FoodCategoryWidget(
                            categoryNumber: 5, foodName: '카페'),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.03,
                        ),
                        const FoodCategoryWidget(
                            categoryNumber: 6, foodName: '분식'),
                        const FoodCategoryWidget(
                            categoryNumber: 7, foodName: '디저트'),
                        const FoodCategoryWidget(
                            categoryNumber: 8, foodName: '야식'),
                        const FoodCategoryWidget(
                            categoryNumber: 9, foodName: '도시락'),
                        const FoodCategoryWidget(
                            categoryNumber: 10, foodName: '기타'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.42,
              margin: const EdgeInsets.only(bottom: 15, left: 5, right: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 2.0,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                    onTap: widget.onMapTap, child: const NaverMapApp()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
