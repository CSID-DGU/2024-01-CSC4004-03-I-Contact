import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Center(child: Text('내 주문')),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const SingleChildScrollView(
        child: Column(
          children: [
            MyOrderWidget(
              orderDate: '2024-01-04',
              orderRestaurant: '동국치킨1',
              orderCount: '10',
              initialIsFinished: false,
            ),
            MyOrderWidget(
              orderDate: '2024-01-03',
              orderRestaurant: '동국치킨2',
              orderCount: '20',
              initialIsFinished: false,
            ),
            MyOrderWidget(
              orderDate: '2024-01-02',
              orderRestaurant: '동국치킨3',
              orderCount: '30',
              initialIsFinished: true,
            ),
            MyOrderWidget(
              orderDate: '2024-01-01',
              orderRestaurant: '동국치킨4',
              orderCount: '40',
              initialIsFinished: true,
            ),
          ],
        ),
      ),
    );
  }
}
