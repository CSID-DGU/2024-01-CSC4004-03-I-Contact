import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Screen/Order_Manage/order_detail_page.dart';
import 'package:leftover_is_over_owner/Services/order_services.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';

class OrderCard extends StatefulWidget {
  final OrderModel order;
  final VoidCallback refreshOrder;
  const OrderCard(this.order, this.refreshOrder, {super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late String orderDate;
  late String orderStatus;
  late int orderNum;
  late List<OrderedFoodInfo> orderedFoodList;
  late String payType;
  late String firstFood;
  late int firstFoodCnt;
  late int menuCnt;

  @override
  void initState() {
    super.initState();
    orderDate = widget.order.orderDate;
    orderStatus = widget.order.status;
    orderNum = widget.order.orderNum;
    orderedFoodList = widget.order.orderedFoodInfo;
    widget.order.appPay ? payType = "앱" : payType = "현장";
    firstFood = orderedFoodList[0].name;
    firstFoodCnt = orderedFoodList[0].count;
    menuCnt = orderedFoodList.length;
  }

  void orderComplete() async {
    var check = await OrderService.orderCheck(widget.order.orderNum, true);
    if (!check) {
      var message = "주문 확인을 실패했습니다";
      if (mounted) {
        showErrorDialog(context, message);
      }
    } else {
      widget.refreshOrder(); // 여기에 괄호를 추가하여 함수 호출
    }
  }

  void orderCancel() async {
    var check = await OrderService.orderCheck(widget.order.orderNum, false);
    if (!check) {
      var message = "주문 취소를 실패했습니다";
      if (mounted) {
        showErrorDialog(context, message);
      }
    } else {
      widget.refreshOrder(); // 여기에 괄호를 추가하여 함수 호출
    }
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
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailPage(widget.order),
                  ),
                );
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
                                  width: 3,
                                ),
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 222, 234, 187),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              '주문 번호: $orderNum',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: GestureDetector(
                              onTap: orderComplete,
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
                                    color: Color.fromARGB(255, 186, 85, 28),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                  menuCnt == 1
                                      ? ' 메뉴: $firstFood $firstFoodCnt개'
                                      : ' 메뉴: $firstFood $firstFoodCnt개 외',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  ' $payType결제',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 15),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('주문 취소'),
                                      content: Text(message),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('아니오'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('네'),
                                          onPressed: () {
                                            orderCancel();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
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
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 82, 59, 42),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
