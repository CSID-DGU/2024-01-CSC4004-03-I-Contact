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
          title: const Center(
              child: Text(
            '내 주문',
            style: TextStyle(fontWeight: FontWeight.w600),
          )),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const MyOrderWidget());
  }
}
