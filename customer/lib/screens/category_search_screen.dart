import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screen.dart';
import 'package:leftover_is_over_customer/widgets/resturant_widget.dart';

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
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return RestaurantWidget(
              restaurantName: '식당 $index', restaurantLocation: '위치 $index');
        },
      ),
    );
  }
}
