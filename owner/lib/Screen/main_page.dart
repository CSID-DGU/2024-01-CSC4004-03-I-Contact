import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Model/store_model.dart';
import 'package:leftover_is_over_owner/Screen/login_page.dart';
import 'package:leftover_is_over_owner/Screen/member_info_page.dart';
import 'package:leftover_is_over_owner/Screen/menu_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/order_status_page.dart';
import 'package:leftover_is_over_owner/Screen/sales_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/store_info_page.dart';
import 'package:leftover_is_over_owner/Services/api_services.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<StoreModel> stores;
  late String currentState; // 매장의 현재 상태 서버로부터 가져와야함. 판매 중인지 일시 정지인지 마감인지
  late String storeName; // 이것도 late로 받아오기
  bool _isDropdownVisible = false;
  bool isLoading = true; // 로딩 중인지
  double _opacity = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStore();
    currentState = "판매 중";
    storeName = "식당이름";
  }

  void _loadStore() async {
    stores = await ApiService.getStores();
    setState(() {
      isLoading = false;
    });
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
      _opacity = _isDropdownVisible ? 0.95 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[600],
      body //:  isLoading
          //? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          const Icon(Icons.restaurant_outlined),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                storeName,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    '현재상태: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    currentState,
                                    style: TextStyle(
                                      color: currentState == '판매 중'
                                          ? Colors.green
                                          : currentState == '일시정지'
                                              ? Colors.red
                                              : Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 190,
                          ),
                          Container(
                            height: 30,
                            width: 3,
                            color: Colors.black,
                          ),
                          IconButton(
                            onPressed: () {
                              _toggleDropdown();
                            }, // 환경 설정 버튼 눌렀을 때 함수 구현하기
                            icon: const Icon(Icons.settings),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 90,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SalesManagePage()));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 55, horizontal: 93),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
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
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MenuManagePage()));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 55, horizontal: 93),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
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
                          builder: (context) => const OrderStatusPage()));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 55, horizontal: 93),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    '주문 현황',
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
          Visibility(
            visible: _isDropdownVisible,
            child: Positioned(
              top:
                  130, // Adjust this to place the dropdown in the correct position
              left:
                  220, // Adjust this to place the dropdown in the correct position
              right:
                  0, // Adjust this to place the dropdown in the correct position
              bottom:
                  0, // Adjust this to place the dropdown in the correct position

              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: const Color.fromARGB(255, 235, 230, 230),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isDropdownVisible,
            child: Positioned(
              top:
                  130, // Adjust this to place the dropdown in the correct position
              left:
                  220, // Adjust this to place the dropdown in the correct position
              right:
                  0, // Adjust this to place the dropdown in the correct position
              bottom:
                  0, // Adjust this to place the dropdown in the correct position

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 35),
                  Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                        ),
                        width: 159,
                        height: 50,
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text(
                            "회원 정보",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                        ),
                        width: 159,
                        height: 50,
                        child: ListTile(
                          leading: const Icon(Icons.store),
                          title: const Text(
                            "가게 정보",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
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
                  const SizedBox(height: 450),
                  Row(
                    children: [
                      const SizedBox(
                        width: 13,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                        ),
                        width: 150,
                        height: 50,
                        child: ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text(
                            "로그아웃",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          onTap: () {
                            _isDropdownVisible = false;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
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
