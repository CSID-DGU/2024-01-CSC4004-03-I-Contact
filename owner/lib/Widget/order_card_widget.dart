import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Screen/Main/login_page.dart';
import 'package:leftover_is_over_owner/Screen/Order_Manage/order_detail_page.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';

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
  late List<OrderedFoodInfo> orderedFoodList;
  late String payType;
  late String firstFood;
  late int firstFoodCnt;
  late int menuCnt;
  @override
  void initState() {
    orderDate = widget.order.orderDate;
    orderStatus = widget.order.status;
    orderNum = widget.order.orderNum;
    orderedFoodList = widget.order.orderedFoodInfo;
    widget.order.appPay ? payType = "앱" : payType = "현장";
    firstFood = orderedFoodList[0].name; // 주문한 음식 배열 중 첫번째 음식의 이름
    firstFoodCnt = orderedFoodList[0].count;
    menuCnt = orderedFoodList.length;
  }

  var message = '주문을 취소하겠습니까?';

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
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                                fontSize: 25,
                                fontFamily: "Free2",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 70),
                            child: Text(
                              '$payType결제',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 120, 120, 120),
                                fontSize: 15,
                                fontFamily: "Free2",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menuCnt == 1
                                      ? '메뉴: $firstFood $firstFoodCnt개'
                                      : '메뉴: $firstFood $firstFoodCnt개 ...', // 메뉴가 다수일 경우
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontFamily: "Free2",
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showYesNoDialog(context, message);
                                },
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
                                    '주문 취소',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Free2",
                                      color: Color.fromARGB(255, 82, 59, 42),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
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
                                      fontFamily: "Free2",
                                      color: Color.fromARGB(255, 186, 85, 28),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
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
