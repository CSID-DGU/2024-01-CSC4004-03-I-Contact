import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screen.dart';

class CategorySearchScreen extends StatefulWidget {
  final String foodName;

  const CategorySearchScreen({super.key, required this.foodName});

  @override
  State<CategorySearchScreen> createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends State<CategorySearchScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodName), // foodName을 AppBar의 제목으로 사용
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RestaurantScreen(),
            ),
          );
        },
        child: Column(
          children: [
            SizedBox(
              width: screenWidth * 0.5,
              height: screenHeight * 0.1,
              child: Text(
                '치킨집A',
                style: TextStyle(fontSize: screenWidth * 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
