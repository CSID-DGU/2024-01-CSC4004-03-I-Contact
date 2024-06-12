import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Services/order_services.dart';
import 'package:leftover_is_over_owner/Services/store_services.dart';
import 'package:leftover_is_over_owner/Widget/order_card_widget.dart';
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
  List<OrderModel> _orderList = [];
  StompClient? stompClient;
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
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var order = snapshot.data![index];
                      return OrderCard(order);
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
