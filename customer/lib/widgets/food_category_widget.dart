import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leftover_is_over_customer/screens/category_search_screen.dart';

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
