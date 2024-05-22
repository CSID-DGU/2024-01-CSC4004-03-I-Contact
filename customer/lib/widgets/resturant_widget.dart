import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screen.dart';

class RestaurantWidget extends StatefulWidget {
  const RestaurantWidget({
    super.key,
    required this.restaurantName,
    required this.restaurantLocation,
  });
  final String restaurantName, restaurantLocation;
  @override
  State<RestaurantWidget> createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RestaurantScreen(
                    restaurantName: widget.restaurantName,
                  )),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.black12, width: 1),
            )),
        width: screenWidth,
        height: 0.25 * screenHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02,
            horizontal: screenWidth * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.restaurantName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenHeight * 0.032,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                widget.restaurantLocation,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: screenHeight * 0.022,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/chicken.jpg',
                      width: 0.25 * screenWidth,
                      height: 0.09 * screenHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/chicken.jpg',
                      width: 0.25 * screenWidth,
                      height: 0.09 * screenHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/chicken.jpg',
                      width: 0.25 * screenWidth,
                      height: 0.09 * screenHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
