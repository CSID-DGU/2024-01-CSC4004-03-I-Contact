import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Model/store_model.dart';
import 'package:leftover_is_over_owner/Screen/Main/login_page.dart';
import 'package:leftover_is_over_owner/Screen/Main/member_info_page.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/Sales_Manage/sales_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/Order_Manage/order_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/Main/store_info_page.dart';
import 'package:leftover_is_over_owner/Services/auth_services.dart';
import 'package:leftover_is_over_owner/Services/user_services.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';
import 'dart:ui';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late StoreModel store;
  late StoreState currentState;
  late String storeName; // 이것도 late로 받아오기
  bool _isDropdownVisible = false;
  bool isLoading = true; // 로딩 중인지
  double _opacity = 0.0;
  late String currentStateS;
  @override
  void initState() {
    super.initState();
    _loadStore();
  }

  void _loadStore() async {
    store = await UserService.getStoreInfo();
    setState(() {
      isLoading = false;
      currentState = store.isOpen ? StoreState.selling : StoreState.closed;
      currentStateS = currentState == StoreState.selling ? "판매 중" : "마감";
      storeName = store.name;
    });
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
      _opacity = _isDropdownVisible ? 0.95 : 0.0;
    });
  }

  void _logout() async {
    _isDropdownVisible = false;
    var logout = await AuthService
        .logout(); // async 가 되어있어야하는지 유의 future<bool>이 넘어오기 때문에
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

  String statusMessage() {
    // 현재 상태 출력
    switch (currentState) {
      case StoreState.selling:
        return '판매 중';
      case StoreState.paused:
        return '일시 중단';
      case StoreState.closed:
        return '마감';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      '현재상태: ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      currentStateS,
                      style: TextStyle(
                        color: currentStateS == '판매 중'
                            ? Colors.green
                            : currentStateS == '마감'
                                ? Colors.red
                                : Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
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
                                      OrderManagePage(currentState)));
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
                              fontWeight: FontWeight.w600,
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
                                      MenuManagePage(currentState)));
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
                              fontWeight: FontWeight.w600,
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
                                      const SalesManagePage()));
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
                              fontWeight: FontWeight.w600,
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
                  child: Positioned(
                    top: 0,
                    left: 170,
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
                    left: 170,
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  _isDropdownVisible = false;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MemberInfoPage()));
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  _isDropdownVisible = false;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const StoreInfoPage()));
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
                              width: 200,
                              height: 50,
                              child: ListTile(
                                leading: const Icon(
                                  Icons.receipt_long,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "전체 주문 내역",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  _isDropdownVisible = false;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const StoreInfoPage()));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 370),
                        Row(
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
                                      fontWeight: FontWeight.w600,
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
