import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Screen/Main/login_page.dart';
import 'package:leftover_is_over_owner/Screen/Order_Manage/order_detail_page.dart';

// 판매관리 주문 내역 카드 생성하는 위젯 주문 개수에 따라 자동으로 Contanier가 생성되도록 수정 예정

class OrderCard extends StatefulWidget {
  final OrderModel order;

  const OrderCard(
    this.order, {
    super.key,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late String orderDate;
  late String orderStatus; // 주문 상태 visit complete order cancel
  late int orderNum; // 주문번호
  late List<OrderInfoModel> orderInfo;
  late String payType;
  late String firstFood;
  @override
  void initState() {
    orderDate = widget.order.orderDate;
    orderStatus = widget.order.status;
    orderNum = widget.order.orderNum;
    orderInfo = widget.order.orderInfo;
    widget.order.appPay ? payType = "앱" : payType = "현장";
    firstFood = orderInfo[0].name; // 주문한 음식 배열 중 첫번째 음식의 이름
  }

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
                        builder: (context) => OrderDetailPage(widget.order)));
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
                              '주문 번호: $orderNum',
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
                                '메뉴: $firstFood',
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
