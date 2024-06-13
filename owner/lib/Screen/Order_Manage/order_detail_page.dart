import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderModel order;
  const OrderDetailPage(this.order, {super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late final String orderDate;

  @override
  void initState() {
    super.initState();
    orderDate = widget.order.orderDate;
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.order.customer;
    final orderedFood = widget.order.orderedFoodInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('주문 상세 정보'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '고객 정보',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text('이름: ${customer.username}'),
            Text('전화번호: ${customer.phone}'),
            Text('이메일: ${customer.email}'),
            const Divider(height: 20, thickness: 2),
            const Text(
              '주문 정보',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text('주문 번호: ${widget.order.orderNum}'),
            Text('주문 날짜: $orderDate'),
            Text('주문 상태: ${widget.order.status}'),
            Text('결제 방식: ${widget.order.appPay ? "앱 결제" : "현장 결제"}'),
            const Divider(height: 20, thickness: 2),
            const Text(
              '주문한 음식',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderedFood.length,
              itemBuilder: (context, index) {
                final food = orderedFood[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('수량: ${food.count}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
