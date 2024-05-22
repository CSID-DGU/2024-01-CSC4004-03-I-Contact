import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screen.dart';
import 'package:leftover_is_over_customer/widgets/notice_widget.dart';

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
              builder: (context) => const RestaurantScreen(
                restaurantName: '알림',
              ),
            ),
          );
        },
        child: const Column(
          children: [
            NoticeWidget(
                noticeDate: '05-21',
                noticeTime: '16:00',
                noticeRestaurant: '식당123',
                noticeRemaining: '12',
                isFinished: false),
            NoticeWidget(
                noticeDate: '05-21',
                noticeTime: '16:00',
                noticeRestaurant: '식당12',
                noticeRemaining: '12',
                isFinished: false),
            NoticeWidget(
                noticeDate: '05-21',
                noticeTime: '16:00',
                noticeRestaurant: '식당1',
                noticeRemaining: '12',
                isFinished: true),
            NoticeWidget(
                noticeDate: '05-21',
                noticeTime: '16:00',
                noticeRestaurant: '식당3',
                noticeRemaining: '12',
                isFinished: true),
          ],
        ),
      ),
    );
  }
}
