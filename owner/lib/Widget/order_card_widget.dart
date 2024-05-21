import 'package:flutter/material.dart';

// 판매관리 주문 내역 카드 생성하는 위젯 주문 개수에 따라 자동으로 Contanier가 생성되도록 수정 예정

class OrderCard extends StatelessWidget {
  final String menuName, payType;
  final int customerNum;

  const OrderCard({
    super.key,
    required this.menuName,
    required this.payType,
    required this.customerNum,
  });

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
                                      color: Color.fromARGB(255, 222, 234, 187),
                                      width: 3),
                                  bottom: BorderSide(
                                      color: Color.fromARGB(255, 222, 234, 187),
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
                          offset: const Offset(-5, -5),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 130,
                              height: 70,
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
        ],
      ),
    );
  }
}
