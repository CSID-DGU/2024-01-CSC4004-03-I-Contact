import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Screen/Order_Manage/order_detail_page.dart';
import 'package:leftover_is_over_owner/Services/order_services.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart'; // OrderCard 위젯이 필요합니다.

class OrderListPage extends StatefulWidget {
  final int storeId;
  const OrderListPage({required this.storeId, super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<OrderModel> _orderList = [];
  StreamController<List<OrderModel>> orderStreamController =
      StreamController<List<OrderModel>>();
  late Future<List<OrderModel>> initialOrderList;
  StompClient? stompClient;
  void _initializeWebSocket() {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://loio-server.azurewebsites.net/ws',
        onConnect: onConnectCallback,
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
      ),
    );
    stompClient!.activate();
  }

  void onConnectCallback(StompFrame frame) {
    print('Connected to WebSocket server');
    print('Subscribing to topic: /topic/order/${widget.storeId}');
    stompClient!.subscribe(
      destination: '/topic/order/${widget.storeId}',
      callback: (frame) {
        if (frame.body != null) {
          final List<dynamic> orderList = jsonDecode(frame.body!);
          List<OrderModel> orders = orderList
              .map((orderJson) => OrderModel.fromJson(orderJson))
              .toList();
          for (var temp in orderList) {
            print('API로부터 받은 주문 $temp');
          }
          setState(() {
            _orderList = orders;
            orderStreamController.add(orders);
          });
        }
      },
    );
  }

  Future<void> _loadInitialOrders() async {
    try {
      List<OrderModel> orders = await initialOrderList;
      setState(() {
        _orderList = orders;
        orderStreamController.add(orders);
      });
    } catch (e) {
      print('Error loading initial orders: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    initialOrderList = OrderService.getOrderList(true);
    _initializeWebSocket();
    _loadInitialOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '전체 주문 내역  ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<OrderModel>>(
              stream: orderStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String payType = "";
                        var order = snapshot.data![
                            snapshot.data!.length - 1 - index]; // 역순 인덱스 사용
                        order.appPay ? payType = "앱" : payType = "현장";
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailPage(order),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5,
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 222, 234, 187),
                                                      width: 3,
                                                    ),
                                                    bottom: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 222, 234, 187),
                                                      width: 3,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  '주문번호: ${order.orderNum}',
                                                  style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      order.orderedFoodInfo
                                                                  .length ==
                                                              1
                                                          ? ' 메뉴: ${order.orderedFoodInfo[0].name} ${order.orderedFoodInfo[0].count}개'
                                                          : ' 메뉴: ${order.orderedFoodInfo[0].name} ${order.orderedFoodInfo[0].count}개 외',
                                                      style: const TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      ' $payType결제',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Colors.orange[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Text(
                          '주문이 존재하지 않습니다',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                      ],
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        '주문이 존재하지 않습니다',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
