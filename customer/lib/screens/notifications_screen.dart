import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'), // foodName을 AppBar의 제목으로 사용
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
                '알림 : 치킨집A',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
