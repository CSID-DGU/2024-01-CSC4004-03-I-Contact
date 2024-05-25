import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Screen/Main/login_page.dart';
import 'package:leftover_is_over_owner/Screen/Order_Manage/order_detail_page.dart';

// 판매관리 주문 내역 카드 생성하는 위젯 주문 개수에 따라 자동으로 Contanier가 생성되도록 수정 예정

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard(
    this.order, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    // 카드 누를시 orderDetailPage로 이동!!
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderDetailPage(order)));
              },
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
                  // 고객 번호, 메뉴 명, 결제 방식 받아와서 출력
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
                                        color:
                                            Color.fromARGB(255, 222, 234, 187),
                                        width: 3),
                                    bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 222, 234, 187),
                                        width: 3))),
                            child: Text(
                              '고객 번호: $customerNum',
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w600),
                            ),
                          ),

                          // 우측 상단 X 버튼 -> 누르면 주문 취소 팝업 뜨도록 수정 필요
                          // 주문취소 -> 남은 수량 관련 데이터 연동
                          Transform.translate(
                            offset: const Offset(10, -10),
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {},
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
                                '메뉴: $menuName',
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '$payType결제',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                          Transform.translate(
                            // 이용확인 버튼 누르면 상태 바뀌도록 수정 필요
                            offset: const Offset(-5, -8),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 100,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  '이용 확인',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 82, 59, 42),
                                  ),
                                ),
                              ),
                            ),
                          )
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
  }
}

// 수동 판매 관리 카드 생성 위젯
class EditOderCard extends StatefulWidget {
  final String menuName;
  final int remainderNum;

  const EditOderCard({
    super.key,
    required this.menuName,
    required this.remainderNum,
  });

  @override
  State<EditOderCard> createState() => _EditOderCardState();
}

class _EditOderCardState extends State<EditOderCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = '0'; // 초기값 설정
  }

// 증가 버튼으로 숫자 증가 함수
  void _increment() {
    setState(() {
      if (_controller.text.isEmpty) {
        _controller.text = "0";
      } else {
        int currentValue = int.parse(_controller.text);

        _controller.text = (currentValue + 1).toString();
      }
    });
  }

  // 감소 버튼으로 숫자 감소 함수
  void _decrement() {
    setState(() {
      if (_controller.text.isEmpty) {
        _controller.text = "0";
      } else {
        int currentValue = int.parse(_controller.text);
        if (currentValue > 0) {
          _controller.text = (currentValue - 1).toString();
        }
      }
    });
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
