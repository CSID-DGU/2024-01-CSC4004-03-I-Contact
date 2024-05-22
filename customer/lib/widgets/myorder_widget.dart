import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screen.dart';

class MyOrderWidget extends StatefulWidget {
  const MyOrderWidget({
    super.key,
    required this.orderDate,
    required this.orderRestaurant,
    required this.orderCount,
    required this.initialIsFinished,
  });
  final String orderDate, orderRestaurant, orderCount;
  final bool initialIsFinished;
  @override
  State<MyOrderWidget> createState() => _MyOrderWidgetState();
}

class _MyOrderWidgetState extends State<MyOrderWidget> {
  late bool isFinished;

  @override
  void initState() {
    super.initState();
    isFinished = widget.initialIsFinished;
  }

  void _toggleOrderStatus() {
    setState(() {
      isFinished = !isFinished;
    });
  }

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
              builder: (context) => const RestaurantScreen(
                    restaurantName: '식당123',
                  )),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border(
            bottom: BorderSide(color: Colors.black12, width: 1),
          ),
        ),
        width: screenWidth,
        height: 0.2 * screenHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.015,
            horizontal: screenWidth * 0.01,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '주문일자(${widget.orderDate})',
                    style: TextStyle(
                      color:
                          isFinished ? const Color(0xFF828282) : Colors.black,
                      fontSize: screenHeight * 0.017,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 0.03 * screenHeight),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/chicken.jpg',
                      width: 0.33 * screenWidth,
                      height: 0.107 * screenHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.orderRestaurant,
                    style: TextStyle(
                      color:
                          isFinished ? const Color(0xFF828282) : Colors.black,
                      fontSize: screenHeight * 0.023,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '신청인원 ${widget.orderCount}명',
                    style: TextStyle(
                      color:
                          isFinished ? const Color(0xFF828282) : Colors.black,
                      fontSize: screenHeight * 0.017,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isFinished ? '마감' : '신청중',
                    style: TextStyle(
                      color:
                          isFinished ? const Color(0xFF828282) : Colors.black,
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _toggleOrderStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFinished
                          ? const Color(0xFFF0F0F0)
                          : const Color(0xFFF0EFFF),
                      foregroundColor:
                          isFinished ? const Color(0xFF828282) : Colors.black,
                      textStyle: TextStyle(
                        fontSize: screenHeight * 0.02,
                      ),
                      minimumSize: const Size(70, 40),
                    ),
                    child: Text(isFinished ? '주문완료' : '방문 취소'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}