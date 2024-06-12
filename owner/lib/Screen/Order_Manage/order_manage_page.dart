import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Screen/Order_Manage/order_detail_page.dart';
import 'package:leftover_is_over_owner/Services/order_services.dart';
import 'package:leftover_is_over_owner/Services/store_services.dart';
import 'package:leftover_is_over_owner/Widget/order_card_widget.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:async';

class OrderManagePage extends StatefulWidget {
  final int storeId;
  const OrderManagePage({required this.storeId, super.key});

  @override
  State<OrderManagePage> createState() => _OrderManagePageState();
}

class _OrderManagePageState extends State<OrderManagePage> {
  bool isLoading = true;
  late bool isOpen;
  late Future<List<OrderModel>> initialOrderList;
  StompClient? stompClient;
  List<OrderModel> _orderList = [];

  final StreamController<List<OrderModel>> _orderStreamController =
      StreamController<List<OrderModel>>();

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    initialOrderList = OrderService.getOrderList(false); // visit인 오더리스트만 보이게
    _getStoreState();
    _initializeWebSocket();
    _loadInitialOrders();
  }

  void refreshOrderList() {
    print("refresh함수에서 refresh");
    if (mounted) {
      setState(() {
        initialOrderList = OrderService.getOrderList(false);
        _loadInitialOrders();
      });
    }
  }

  void _initializeWebSocket() {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url:
            'http://loio-server.azurewebsites.net/ws', // Replace with your server's URL
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
            _orderStreamController.add(orders);
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
        _orderStreamController.add(orders);
      });
    } catch (e) {
      print('Error loading initial orders: $e');
    }
  }

  void orderCancel(int orderNum) async {
    var check = await OrderService.orderCheck(orderNum, false);
    if (!check) {
      var message = "주문 취소를 실패했습니다";
      if (mounted) {
        showErrorDialog(context, message);
      }
    } else {
      // widget.refreshOrder(); // 여기에 괄호를 추가하여 함수 호출
    }
  }

  void orderComplete(int orderNum) async {
    var check = await OrderService.orderCheck(orderNum, true);
    if (!check) {
      var message = "주문 확인을 실패했습니다";
      if (mounted) {
        showErrorDialog(context, message);
      }
    } else {
      //widget.refreshOrder(); // 여기에 괄호를 추가하여 함수 호출
    }
  }

  @override
  void dispose() {
    if (stompClient != null && stompClient!.connected) {
      stompClient!.deactivate();
      print('WebSocket connection deactivated');
    }
    _orderStreamController.close();
    super.dispose();
  }

  Future<void> _getStoreState() async {
    isOpen = await StoreService.getStoreState();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '주문 관리',
              style: TextStyle(
                fontSize: 24,
                fontFamily: "MainButton",
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<OrderModel>>(
              stream: _orderStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var order = snapshot.data![index];
                      String payType = "";
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  orderComplete(order.orderNum);
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 2,
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        offset:
                                                            const Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Text(
                                                    '이용 확인',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromARGB(
                                                          255, 186, 85, 28),
                                                    ),
                                                  ),
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
                                                        ? ' 메뉴: ${order.orderedFoodInfo[0].name}개 외${order.orderedFoodInfo[0].count}'
                                                        : ' 메뉴: ${order.orderedFoodInfo[0].name}개 외',
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
                                                      color: Colors.orange[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, top: 15),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title:
                                                            const Text('주문 취소'),
                                                        content: const Text(
                                                            '주문을 취소하겠습니까?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                '아니오'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child:
                                                                const Text('네'),
                                                            onPressed: () {
                                                              orderCancel(order
                                                                  .orderNum);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 2,
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        offset:
                                                            const Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Text(
                                                    '주문 취소',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromARGB(
                                                          255, 82, 59, 42),
                                                    ),
                                                  ),
                                                ),
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
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(child: Text('조회된 주문이 없습니다'));
                }
              },
            ),
    );
  }
}
