import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leftover_is_over_customer/screens/category_search_screen.dart';
import 'package:leftover_is_over_customer/screens/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      backgroundColor: Theme.of(context).colorScheme.background,
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
                  Container(
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    margin: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColorDark, width: 2),
                      borderRadius: BorderRadius.circular(45),
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.person_2_rounded,
                      size: screenWidth * 0.1,
                      color: Theme.of(context).primaryColorDark,
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
            Container(
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
                        const FoodCategoryWidget(foodName: '한식'),
                        const FoodCategoryWidget(foodName: '중식'),
                        const FoodCategoryWidget(foodName: '일식'),
                        const FoodCategoryWidget(foodName: '양식'),
                        const FoodCategoryWidget(foodName: '카페'),
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
                        const FoodCategoryWidget(foodName: '분식'),
                        const FoodCategoryWidget(foodName: '디저트'),
                        const FoodCategoryWidget(foodName: '야식'),
                        const FoodCategoryWidget(foodName: '도시락'),
                        const FoodCategoryWidget(foodName: '기사'),
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
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('    지도',
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600))),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset('assets/images/square_map.png'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCategoryWidget extends StatelessWidget {
  final String foodName;

  const FoodCategoryWidget({super.key, required this.foodName});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategorySearchScreen(foodName: foodName)),
        );
      },
      child: Container(
        width: screenWidth * 0.13,
        height: screenWidth * 0.13,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(45),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(1),
              spreadRadius: 0,
              blurRadius: 1.0,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.food_bank_rounded,
              color: Theme.of(context).primaryColorDark,
              size: screenWidth * 0.08,
            ),
            Text(
              foodName,
              style: TextStyle(
                  fontSize: screenWidth * 0.025, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('foodName', foodName));
  }
}
