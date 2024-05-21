import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class NoticeWidget extends StatefulWidget {
  const NoticeWidget({
    super.key,
    required this.noticeDate,
    required this.noticeTime,
    required this.noticeRestaurant,
    required this.noticeRemaining,
    required this.isFinished,
  });
  final String noticeDate, noticeTime, noticeRestaurant, noticeRemaining;
  final bool isFinished;
  @override
  State<NoticeWidget> createState() => _NoticeWidgetState();
}

class _NoticeWidgetState extends State<NoticeWidget> {
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
                    restaurantName: widget.RestaurantScreen,
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
        height: 0.15 * screenHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01,
            horizontal: screenWidth * 0.1,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.noticeDate,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: screenHeight * 0.017,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.05,
                      ),
                      Text(
                        widget.noticeTime,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: screenHeight * 0.017,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.001,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.noticeRestaurant,
                        style: TextStyle(
                          color: widget.isFinished
                              ? const Color(0xFF949494)
                              : Colors.black,
                          fontSize: screenHeight * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.isFinished
                            ? '판매종료'
                            : '남은음식 ${widget.noticeRemaining}개',
                        style: TextStyle(
                          color: widget.isFinished
                              ? const Color(0xFF949494)
                              : Colors.black,
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
