import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/widgets/myorder_widget.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  List<Map<String, dynamic>> orders = [
    {
      'orderDate': '2023-05-23',
      'orderRestaurant': '식당314',
      'orderCount': '40000',
    },
    {
      'orderDate': '2023-02-04',
      'orderRestaurant': '식당315',
      'orderCount': '30000',
    },
    {
      'orderDate': '2023-09-14',
      'orderRestaurant': '식당316',
      'orderCount': '20000',
    },
    // Add more orders here
  ];
  void handleOrderFinish(int index) {
    setState(() {
      orders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('내 주문')),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: orders.isEmpty
          ? const Center(child: Text('주문이 없습니다.'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return MyOrderWidget(
                  orderDate: order['orderDate'],
                  orderRestaurant: order['orderRestaurant'],
                  orderPrice: order['orderCount'],
                  onFinish: () => handleOrderFinish(index),
                );
              },
            ),
    );
  }
}
