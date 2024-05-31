import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Services/order_services.dart';
import 'package:leftover_is_over_owner/Services/store_services.dart';
import 'package:leftover_is_over_owner/Widget/order_card_widget.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';

class OrderManagePage extends StatefulWidget {
  final StoreState startState;
  const OrderManagePage(this.startState, {super.key});

  @override
  State<OrderManagePage> createState() => _OrderManagePageState();
}

class _OrderManagePageState extends State<OrderManagePage> {
  late StoreState currentState = widget.startState;
  StoreState? lastState;
  late Future<List<OrderModel>> orderList;

  @override
  void initState() {
    // TODO: implement initState
    var getAll = false;
    orderList = OrderService.getOrderList(getAll);
  }

  void getSalesState() {
    // 매장의 현재 상태를 받아오는 함수
    setState(() {
      if (currentState == StoreState.selling) {
        lastState = currentState;
        currentState = StoreState.paused;
      } else if (currentState == StoreState.paused) {
        lastState = currentState;
        currentState = StoreState.selling;
      }
    });
  }

  void closeSales() {
    // 매장 현재 상태 마감으로 변경하는 함수
    setState(() {
      if (currentState != StoreState.closed) {
        lastState = currentState; // 판매 마감 전 현재 상태를 lastState에 저장
      }
      currentState = StoreState.closed;
    });
  }

  String getButtonText() {
    if (currentState == StoreState.closed) {
      // 판매가 마감된 상태일 때, 마지막 상태에 따라 왼쪽 버튼 텍스트 결정
      if (lastState == StoreState.selling) {
        return '일시 중단';
      } else {
        return '판매 재개';
      }

      // 마감 상태가 아닐때 왼쪽 버튼 텍스트
    } else if (currentState == StoreState.selling) {
      return '일시 중단';
    } else {
      return '판매 재개';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 하단 버튼 칸의 비율을 유지하기 위함
    double bottomSheetHeight = MediaQuery.of(context).size.height * 0.03;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '주문 관리',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: FutureBuilder(
            future: orderList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!
                      .length, // 이게 처음 주문 리스트가 비어있는 경우도 있는데 그러면 널일 수도 있으니까 나중에 !를 ?로 바꿔서 널인경우 따로 처리해야할 수 도 있음!!!!
                  itemBuilder: (context, index) {
                    var order = snapshot.data![index];
                    return OrderCard(order);
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}


// 추후 메뉴 글자 길이가 길어지면 자동으로 줄바꿈되고 
// 이에 따라 주문 카드의 크기도 유동적으로 변하도록 수정필요(중요도 낮음)