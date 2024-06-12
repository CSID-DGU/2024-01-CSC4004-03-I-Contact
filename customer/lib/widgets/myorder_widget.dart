import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/models/get_order_model.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screens/restaurant_screen.dart';
import 'package:leftover_is_over_customer/services/order_services.dart';

class MyOrderWidget extends StatefulWidget {
  const MyOrderWidget({super.key});

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
      return orders ?? []; // Return an empty list if orders is null
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  Future<void> _cancelOrder(int orderNum) async {
    try {
      bool success = await OrderService.deleteOrder(orderId: orderNum);
      if (success) {
        setState(() {
          _futureOrders = _getOrders();
        });
      }
    } catch (e) {
      print('Error canceling order: $e');
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
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text('주문이 없습니다'));
        } else if (snapshot.hasData) {
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[orders.length - 1 - index];
              final bool isCanceled = order.status.toLowerCase() == 'cancel';
              final TextStyle textStyle = TextStyle(
                color: isCanceled ? Colors.grey : Colors.black,
                fontSize: screenHeight * 0.018,
                fontWeight: isCanceled ? FontWeight.normal : FontWeight.w400,
              );

              return GestureDetector(
                onTap: isCanceled
                    ? null
                    : () {
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
                              order.orderDate,
                              style: TextStyle(
                                color: isCanceled ? Colors.grey : Colors.black,
                                fontSize: screenHeight * 0.016,
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
                                      color: isCanceled
                                          ? const Color.fromARGB(
                                                  255, 220, 220, 220)
                                              .withOpacity(0.7)
                                          : null,
                                      colorBlendMode: isCanceled
                                          ? BlendMode.modulate
                                          : null,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/no_image.png',
                                          width: 0.35 * screenWidth,
                                          height: 0.11 * screenHeight,
                                          fit: BoxFit.cover,
                                          color: isCanceled
                                              ? const Color.fromARGB(
                                                      255, 220, 220, 220)
                                                  .withOpacity(0.7)
                                              : null,
                                          colorBlendMode: isCanceled
                                              ? BlendMode.modulate
                                              : null,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/images/no_image.png',
                                      width: 0.35 * screenWidth,
                                      height: 0.11 * screenHeight,
                                      fit: BoxFit.cover,
                                      color: isCanceled
                                          ? const Color.fromARGB(
                                                  255, 220, 220, 220)
                                              .withOpacity(0.7)
                                          : null,
                                      colorBlendMode: isCanceled
                                          ? BlendMode.modulate
                                          : null,
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
                                  color:
                                      isCanceled ? Colors.grey : Colors.black,
                                  fontSize: screenHeight * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.002),
                              if (order.orderedFood.isNotEmpty)
                                Text(
                                  '${order.orderedFood[0].name} 외 ${order.orderedFood.map((food) => food.count).reduce((value, element) => value + element) - order.orderedFood[0].count}개',
                                  style: TextStyle(
                                    color:
                                        isCanceled ? Colors.grey : Colors.black,
                                    fontSize: screenHeight * 0.018,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              if (order.orderedFood.isNotEmpty)
                                SizedBox(height: screenHeight * 0.000),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '주문 번호: ${order.orderNum % 1000}',
                                    style: TextStyle(
                                      color: isCanceled
                                          ? Colors.grey
                                          : Colors.black,
                                      fontSize: screenHeight * 0.018,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: isCanceled
                                        ? null
                                        : () {
                                            _cancelOrder(order.orderNum);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFD700),
                                      foregroundColor: isCanceled
                                          ? Colors.grey
                                          : Colors.black,
                                      textStyle: TextStyle(
                                        fontSize: screenHeight * 0.018,
                                      ),
                                      minimumSize: const Size(70, 35),
                                    ),
                                    child: Text(
                                      '방문취소',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isCanceled
                                            ? Colors.grey
                                            : Colors.black,
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
