import 'package:flutter/material.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(children: [
          Container(
            width: screenWidth,
            height: screenHeight * 0.07,
            margin: EdgeInsets.only(
                top: screenHeight * 0.05,
                bottom: screenHeight * 0.02,
                left: screenHeight * 0.03,
                right: screenHeight * 0.03),
            decoration: BoxDecoration(
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
            child: TextField(
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요.',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black38,
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          const Text('Text')
        ]));
  }
}
