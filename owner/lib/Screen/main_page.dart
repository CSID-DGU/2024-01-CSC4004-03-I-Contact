import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Screen/menu_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/order_status_page.dart';
import 'package:leftover_is_over_owner/Screen/sales_manage_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String currentState = "판매 중"; // 매장의 현재 상태 서버로부터 가져와야함. 판매 중인지 일시 정지인지 마감인지
  String storeName = "식당이름"; // 이것도 late로 받아오기
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[600],
      body: Column(
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
                        width: 160,
                      ),
                      Container(
                        height: 30,
                        width: 3,
                        color: Colors.black,
                      ),
                      IconButton(
                        onPressed: () {}, // 환경 설정 버튼 눌렀을 때 함수 구현하기
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
              padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 93),
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
              padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 93),
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
              padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 93),
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
    );
  }
}
