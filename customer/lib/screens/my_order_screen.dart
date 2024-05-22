import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leftover_is_over_customer/widgets/myorder_widget.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        margin: const EdgeInsets.all(20),
        child: const Column(
          children: [
            Center(
              child: Text(
                '내 주문 탭',
                style: TextStyle(fontSize: 40),
              ),
            ),
            MyOrderWidget(
              orderDate: '2024-01-01',
              orderRestaurant: '동국치킨',
              orderCount: '32',
              initialIsFinished: true,
            )
          ],
        ),
      ),
    );
  }
}
