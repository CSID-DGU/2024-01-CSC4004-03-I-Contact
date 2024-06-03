import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screens/restaurant_screen.dart';

class MyOrderWidget extends StatefulWidget {
  const MyOrderWidget({
    super.key,
    required this.orderDate,
    required this.orderRestaurant,
    required this.orderPrice,
    required this.onFinish,
  });

  final String orderDate, orderRestaurant, orderPrice;
  final VoidCallback onFinish;

  @override
  State<MyOrderWidget> createState() => _MyOrderWidgetState();
}

class _MyOrderWidgetState extends State<MyOrderWidget> {
  @override
  void initState() {
    super.initState();
  }

  void _toggleOrderStatus() {
    setState(() {});
    widget.onFinish();
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
              storeId: 1,
            ),
          ),
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
        height: 0.18 * screenHeight, // 높이 증가
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01,
            horizontal: screenWidth * 0.03,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '주문일자: ${widget.orderDate}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenHeight * 0.018, // 글자 크기 증가
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/chicken.jpg',
                      width: 0.35 * screenWidth, // 너비 증가
                      height: 0.11 * screenHeight, // 높이 증가
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(width: screenWidth * 0.05),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      widget.orderRestaurant,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenHeight * 0.025, // 글자 크기 증가
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.002),
                    Text(
                      '${widget.orderPrice}₩',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenHeight * 0.018,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.000),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '신청중',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _toggleOrderStatus,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700), // 진한 노랑색
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(
                              fontSize: screenHeight * 0.018,
                            ),
                            minimumSize: const Size(70, 35),
                          ),
                          child: const Text(
                            '방문취소',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
