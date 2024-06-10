import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/models/get_order_model.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screens/restaurant_screen.dart';
import 'package:leftover_is_over_customer/services/order_services.dart';

class MyOrderWidget extends StatefulWidget {
  const MyOrderWidget({
    super.key,
    required this.onFinish,
  });

  final bool onFinish;

  @override
  _MyOrderWidgetState createState() => _MyOrderWidgetState();
}

class _MyOrderWidgetState extends State<MyOrderWidget> {
  late Future<List<GetOrderModel>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = _getOrders();
  }

  Future<List<GetOrderModel>> _getOrders() async {
    try {
      final orders = await OrderService.getOrders();
      return orders ?? []; // null인 경우 빈 리스트 반환
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  Future<void> _deleteOrder(int orderNum) async {
    try {
      bool success = await OrderService.deleteOrder(orderId: orderNum);
      if (success) {
        setState(() {
          _futureOrders = _getOrders();
        });
      }
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return FutureBuilder<List<GetOrderModel>>(
      future: _futureOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('주문이 없습니다'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[orders.length - 1 - index]; // 역순으로 접근
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantScreen(
                        storeId: order.store.storeId,
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
                  height: 0.18 * screenHeight,
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
                              '주문: ${order.orderDate}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenHeight * 0.014,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: order.orderedFood.isNotEmpty &&
                                      order.orderedFood[0].imgUrl.isNotEmpty
                                  ? Image.network(
                                      'http://loio-server.azurewebsites.net${order.orderedFood[0].imgUrl}',
                                      width: 0.35 * screenWidth,
                                      height: 0.11 * screenHeight,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/chicken.jpg',
                                          width: 0.35 * screenWidth,
                                          height: 0.11 * screenHeight,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/images/chicken.jpg',
                                      width: 0.35 * screenWidth,
                                      height: 0.11 * screenHeight,
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
                                order.store.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenHeight * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.002),
                              Text(
                                '${order.orderedFood[0].name} 외 ${order.orderedFood.map((food) => food.count).reduce((value, element) => value + element) - order.orderedFood[0].count}개',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenHeight * 0.018,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.000),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order.status,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenHeight * 0.018,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _deleteOrder(order.orderNum);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFD700),
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
            },
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
