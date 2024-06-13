import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:leftover_is_over_owner/Model/store_model.dart';
import 'package:leftover_is_over_owner/Provider/store_state.dart';
import 'package:leftover_is_over_owner/Screen/Main/login_page.dart';
import 'package:leftover_is_over_owner/Screen/Main/member_info_page.dart';
import 'package:leftover_is_over_owner/Screen/Main/order_list_page.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/Sales_Manage/sales_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/Order_Manage/order_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/Main/store_info_page.dart';
import 'package:leftover_is_over_owner/Services/auth_services.dart';
import 'package:leftover_is_over_owner/Services/store_services.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';
import 'dart:ui';

import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late StoreModel store;

  late String storeName; // 이것도 late로 받아오기
  bool _isDropdownVisible = false;
  bool isLoading = true; // 로딩 중인지
  double _opacity = 0.0;
  var messageString = "";

  void sendFirebaseToken() async {
    await StoreService.sendFirebaseToken();
  }

  @override
  void initState() {
    _isDropdownVisible = false;
    _loadStore();
    sendFirebaseToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.max,
        );
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              importance: Importance.max,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: message.data['parameter'],
        );
        setState(() {
          messageString = message.notification!.body!;
          print("Foreground 메시지 수신: $messageString");
        });
      }
    });
    super.initState();
  }

  void _loadStore() async {
    store = await StoreService.getStoreInfo();
    var storeState = context.read<StoreState>();
    storeState.setOpen(store.isOpen); // 초기 상태 주입
    setState(() {
      isLoading = false;
      storeName = store.name;
    });
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
      _opacity = _isDropdownVisible ? 0.95 : 0.0;
    });
  }

  Future<void> _logout() async {
    _isDropdownVisible = false;
    var logout = await AuthService
        .logout(); // async 가 되어있어야하는지 유의 future<bool>이 넘어오기 때문에
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    }

    if (logout) {
      if (!mounted) {
        return;
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      if (!mounted) {
        return;
      }
      showErrorDialog(context, '로그아웃에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 198, 88),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.3),
              title: Row(
                children: [
                  const Icon(Icons.restaurant_outlined, color: Colors.black),
                  const SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        storeName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "MainButton",
                          color: Colors.black,
                        ),
                      ),
                      Consumer<StoreState>(
                          builder: (context, storeState, child) {
                        return Row(
                          children: [
                            const Text(
                              '현재상태: ',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "SubMenu",
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              storeState.isOpen ? "판매 중" : "판매 마감",
                              style: TextStyle(
                                color: storeState.isOpen
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 13,
                                fontFamily: "SubMenu",
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _toggleDropdown();
                    },
                    icon: const Icon(Icons.menu, color: Colors.black),
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                GestureDetector(
                  onTap: _isDropdownVisible ? _toggleDropdown : null,
                  child: Container(
                    color: Colors.transparent, // 투명한 배경을 사용하여 터치 이벤트를 감지
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SalesManagePage(storeId: store.storeId)));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 55, horizontal: 93),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 4),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            '판매 관리',
                            style: TextStyle(
                              color: Colors.brown[600],
                              fontSize: 30,
                              fontFamily: "Test",
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MenuManagePage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 55, horizontal: 93),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 4),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            '메뉴 관리',
                            style: TextStyle(
                              color: Colors.brown[600],
                              fontSize: 30,
                              fontFamily: "Test",
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderManagePage(
                                        storeId: store.storeId,
                                      )));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 55, horizontal: 93),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 4),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            '이용 확인',
                            style: TextStyle(
                              color: Colors.brown[600],
                              fontSize: 30,
                              fontFamily: "Test",
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _isDropdownVisible,
                  child: GestureDetector(
                    onTap: _toggleDropdown,
                    child: Container(
                      color: Colors.black.withOpacity(0.2), // 드롭다운 뒤에 투명한 레이어
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                Visibility(
                  visible: _isDropdownVisible,
                  child: Positioned(
                    top: 0,
                    left: 190,
                    right: 0,
                    bottom: 0,
                    child: AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 300),
                      child: ClipRect(
                        // ClipRect를 추가하여 BackdropFilter의 범위를 제한.
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 10.0, sigmaY: 10.0), // 블러 효과 적용
                          child: Container(
                            alignment: Alignment.center,
                            color: const Color.fromARGB(255, 112, 120, 91)
                                .withOpacity(0.93), // 원하는 컨테이너 색상
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isDropdownVisible,
                  child: Positioned(
                    top: 0,
                    left: 186,
                    right: 0,
                    bottom: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 35),
                        Row(
                          children: [
                            const SizedBox(
                              width: 12,
                            ),
                            SizedBox(
                              width: 159,
                              height: 50,
                              child: ListTile(
                                leading: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "회원 정보",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "SubMenu",
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  _isDropdownVisible = false;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MemberInfoPage(),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      _isDropdownVisible =
                                          false; // 페이지 이동 후 돌아왔을 때 드롭다운 메뉴 숨기기
                                    });
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const SizedBox(
                              width: 12,
                            ),
                            SizedBox(
                              width: 159,
                              height: 50,
                              child: ListTile(
                                leading: const Icon(
                                  Icons.store,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "가게 정보",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "SubMenu",
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  _isDropdownVisible = false;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const StoreInfoPage()),
                                  ).then((_) {
                                    setState(() {
                                      _isDropdownVisible =
                                          false; // 페이지 이동 후 돌아왔을 때 드롭다운 메뉴 숨기기
                                    });
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const SizedBox(
                              width: 12,
                            ),
                            SizedBox(
                              width: 186,
                              height: 50,
                              child: ListTile(
                                leading: const Icon(
                                  Icons.receipt_long,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "전체 주문 내역",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "SubMenu",
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  _isDropdownVisible = false;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderListPage(
                                            storeId: store.storeId)),
                                  ).then((_) {
                                    setState(() {
                                      _isDropdownVisible =
                                          false; // 페이지 이동 후 돌아왔을 때 드롭다운 메뉴 숨기기
                                    });
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 400),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 13,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 150,
                              height: 50,
                              child: ListTile(
                                leading: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "로그아웃",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "SubMenu",
                                      color: Colors.white),
                                ),
                                onTap: _logout,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
