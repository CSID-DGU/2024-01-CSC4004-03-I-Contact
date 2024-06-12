import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Provider/store_state.dart';
import 'package:leftover_is_over_owner/Services/menu_services.dart';
import 'package:leftover_is_over_owner/Services/store_services.dart';
import 'package:leftover_is_over_owner/Widget/sales_card_widget.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:async';

class SalesManagePage extends StatefulWidget {
  final int storeId;
  const SalesManagePage({required this.storeId, super.key});
  @override
  State<SalesManagePage> createState() => SalesManagePageState();
}

class SalesManagePageState extends State<SalesManagePage> {
  Future<List<MenuModel>> initialMenuList = MenuService.getVisibleMenuList();
  StompClient? stompClient;
  List<MenuModel> _menuList = [];
  final StreamController<List<MenuModel>> _menuStreamController =
      StreamController<List<MenuModel>>();

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    _loadInitialMenus();
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
    print('Subscribing to topic: /topic/store/${widget.storeId}');
    stompClient!.subscribe(
      destination: '/topic/store/${widget.storeId}',
      callback: (frame) {
        if (frame.body != null) {
          final List<dynamic> menuList = jsonDecode(frame.body!);
          List<MenuModel> menus =
              menuList.map((menuJson) => MenuModel.fromJson(menuJson)).toList();
          print('웹소켓 $menus');
          setState(() {
            _menuList = menus;
            _menuStreamController.add(menus);
          });
        }
      },
    );
  }

  Future<void> _loadInitialMenus() async {
    try {
      List<MenuModel> menus = await initialMenuList;
      setState(() {
        _menuList = menus;
        _menuStreamController.add(menus);
      });
    } catch (e) {
      print('Error loading initial menus: $e');
    }
  }

  void refreshMenuList() {
    if (mounted) {
      setState(() {
        initialMenuList = MenuService.getVisibleMenuList();
        _loadInitialMenus();
      });
    }
  }

  void closeStoreButton() async {
    var storeState = context.read<StoreState>();
    if (storeState.isOpen) {
      storeState.toggleStore();
    }
    try {
      await StoreService.changeStoreState();
      List<Future> futures = [];
      List<MenuModel> menus = await MenuService.getMenuList();
      String capacity = '0';
      bool visible = false;
      for (var menu in menus) {
        futures.add(MenuService.setMenu(
            foodId: menu.foodId, capacity: capacity, visible: visible));
      }
      await Future.wait(futures);
      refreshMenuList();
    } catch (e) {
      print(e);
    }
  }

  void updateMenuCapacity(int foodId, int remainder, bool add) async {
    await MenuService.updateMenuCapacity(foodId, add);
    refreshMenuList();
  }

  @override
  void dispose() {
    if (stompClient != null && stompClient!.connected) {
      stompClient!.deactivate();
      print('WebSocket connection deactivated');
    }
    _menuStreamController.close();
    super.dispose();
  }

// 증가 버튼으로 숫자 증가 함수
  void _increment(int foodId, int capacity) {
    var storeState = context.read<StoreState>();
    storeState.refreshSalesCallback();
    updateMenuCapacity(foodId, capacity, true);
  }

  // 감소 버튼으로 숫자 감소 함수
  void _decrement(int foodId, int capacity) {
    var storeState = context.read<StoreState>();
    storeState.refreshSalesCallback();
    if (capacity > 0) {
      updateMenuCapacity(foodId, capacity, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 하단 버튼 칸의 비율을 유지하기 위함
    double bottomSheetHeight = MediaQuery.of(context).size.height * 0.10;

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
                '판매 관리  ',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "MainButton",
                ),
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<StoreState>(builder: (context, storeState, child) {
                return ShowSalesStatus(
                  // 매장 현재상태 보여주는 위젯
                  isOpen: storeState.isOpen,
                );
              }),
              Consumer<StoreState>(builder: (context, storeState, child) {
                return IgnorePointer(
                  ignoring: !storeState.isOpen, // 닫혀있으면 수정할 수 없어!!
                  child: StreamBuilder<List<MenuModel>>(
                      stream: _menuStreamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          return ListView.separated(
                            shrinkWrap: true, // 스크롤 뷰 내에서 사용될 때 크기를 조정함
                            physics:
                                const NeverScrollableScrollPhysics(), // ListView 자체 스크롤을 비활성화
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length, // 추가 버튼을 위해 +1
                            itemBuilder: (context, index) {
                              var menu = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 5,
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          // 메뉴 명, 남은 개수 받아와서 출력
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    decoration: const BoxDecoration(
                                                        border: Border(
                                                            top: BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        222,
                                                                        234,
                                                                        187),
                                                                width: 3),
                                                            bottom: BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        222,
                                                                        234,
                                                                        187),
                                                                width: 3))),
                                                    child: Text(
                                                      menu.name,
                                                      style: const TextStyle(
                                                        fontSize: 25,
                                                        fontFamily: "Free2",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '남은 수량: ${menu.capacity}',
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: "Free2",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    height: 60,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        // 개수 감소 버튼
                                                        IconButton(
                                                          onPressed: () {
                                                            _decrement(
                                                                menu.foodId,
                                                                menu.capacity);
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .remove_circle_outline_outlined,
                                                            size: 40,
                                                            color: Colors.black,
                                                          ),
                                                        ),

                                                        // 개수 증가 버튼
                                                        // 판매 관리에서 등록한 개수보다 늘어날 수 없음
                                                        IconButton(
                                                          onPressed: () {
                                                            _increment(
                                                                menu.foodId,
                                                                menu.capacity);
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .add_circle_outline_outlined,
                                                            size: 40,
                                                            color: Colors.black,
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
                                  ],
                                ),
                              );
                              return null;
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 5,
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return const Center(child: Text('메뉴를 등록해주세요'));
                        }
                      }),
                );
              })
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                // 오른쪽 하단 버튼
                onTap: closeStoreButton,
                child: Container(
                  height: 70,
                  width: 150,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                        color: Colors.black.withOpacity(0.4),
                      )
                    ],
                    color: !context.watch<StoreState>().isOpen
                        ? const Color.fromARGB(255, 210, 210, 210)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      '판매 마감',
                      style: TextStyle(
                        color: !context.watch<StoreState>().isOpen
                            ? const Color.fromARGB(255, 120, 120, 120)
                            : Colors.red,
                        fontFamily: "Free2",
                        fontSize: 23,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
