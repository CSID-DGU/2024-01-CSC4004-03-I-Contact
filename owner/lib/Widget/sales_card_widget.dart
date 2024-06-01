import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Screen/Main/login_page.dart';
import 'package:leftover_is_over_owner/Screen/Order_Manage/order_detail_page.dart';

class SalesCard extends StatefulWidget {
  final int foodId;
  final String menuName;
  final int remainderNum;
  final Function(bool) updateMenuCapacity;
  const SalesCard({
    required this.foodId,
    required this.menuName,
    required this.remainderNum,
    required this.updateMenuCapacity,
    super.key,
  });

  @override
  State<SalesCard> createState() => _SalesCardState();
}

class _SalesCardState extends State<SalesCard> {
  @override
  void initState() {
    super.initState();
  }

// 증가 버튼으로 숫자 증가 함수
  void _increment() {
    widget.updateMenuCapacity(true);
  }

  // 감소 버튼으로 숫자 감소 함수
  void _decrement() {
    if (widget.remainderNum > 0) {
      widget.updateMenuCapacity(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 150,
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
                // 메뉴 명, 남은 개수 받아와서 출력
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Color.fromARGB(255, 222, 234, 187),
                                      width: 3),
                                  bottom: BorderSide(
                                      color: Color.fromARGB(255, 222, 234, 187),
                                      width: 3))),
                          child: Text(
                            widget.menuName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '남은 수량: ${widget.remainderNum}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 150,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // 개수 감소 버튼
                              IconButton(
                                onPressed: _decrement,
                                icon: const Icon(
                                  Icons.remove_circle_outline_outlined,
                                  size: 40,
                                  color: Colors.black,
                                ),
                              ),

                              // 개수 증가 버튼
                              // 판매 관리에서 등록한 개수보다 늘어날 수 없음
                              IconButton(
                                onPressed: _increment,
                                icon: const Icon(
                                  Icons.add_circle_outline_outlined,
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
  }
}
