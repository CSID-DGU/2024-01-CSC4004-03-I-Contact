import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Widget/order_card_widget.dart';
import 'package:leftover_is_over_owner/Widget/sales_state_widget.dart';

class SalesManagePage extends StatefulWidget {
  const SalesManagePage({super.key});

  @override
  State<SalesManagePage> createState() => SalesManagePageState();
}

class SalesManagePageState extends State<SalesManagePage> {
  SalesState currentState = SalesState.selling;
  SalesState? lastState;

  void getSalesState() {
    // 매장의 현재 상태를 받아오는 함수
    setState(() {
      if (currentState == SalesState.selling) {
        lastState = currentState;
        currentState = SalesState.paused;
      } else if (currentState == SalesState.paused) {
        lastState = currentState;
        currentState = SalesState.selling;
      }
    });
  }

  void closeSales() {
    // 매장 현재 상태 마감으로 변경하는 함수
    setState(() {
      if (currentState != SalesState.closed) {
        lastState = currentState; // 판매 마감 전 현재 상태를 lastState에 저장
      }
      currentState = SalesState.closed;
    });
  }

  String statusMessage() {
    // 현재 상태 출력
    switch (currentState) {
      case SalesState.selling:
        return '판매 중';
      case SalesState.paused:
        return '일시 중단';
      case SalesState.closed:
        return '마감';
    }
  }

  String getButtonText() {
    if (currentState == SalesState.closed) {
      // 판매가 마감된 상태일 때, 마지막 상태에 따라 왼쪽 버튼 텍스트 결정
      if (lastState == SalesState.selling) {
        return '일시 중단';
      } else {
        return '판매 재개';
      }

      // 마감 상태가 아닐때 왼쪽 버튼 텍스트
    } else if (currentState == SalesState.selling) {
      return '일시 중단';
    } else {
      return '판매 재개';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 하단 버튼 칸의 비율을 유지하기 위함
    double bottomSheetHeight = MediaQuery.of(context).size.height * 0.10;

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
                '판매 관리  ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              bottom:
                  // 하단 버튼 칸
                  bottomSheetHeight + MediaQuery.of(context).viewInsets.bottom),
          child: Column(children: [
            ShowSalesStatus(
              // 매장 현재상태 보여주는 위젯
              statusMessage: statusMessage(),
              currentState: currentState,
            ),
            const Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Column(
                    // 추후 주문 데이터에 따라 자동으로 OrderCard 생성토록 할 것
                    children: [
                      EditOderCard(
                        // 주문 내역 위젯
                        menuName: '가나다',
                        remainderNum: 5,
                      ),
                      EditOderCard(
                        menuName: '라마바',
                        remainderNum: 3,
                      ),
                      EditOderCard(
                        menuName: '사아자',
                        remainderNum: 3,
                      ),
                      EditOderCard(
                        menuName: '차카타',
                        remainderNum: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
        bottomSheet: Container(
          color: Colors.white,
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                // 왼쪽 하단 버튼
                onTap: getSalesState,
                child: Container(
                  height: 70,
                  width: 150,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                        color: Colors.black.withOpacity(0.4),
                      )
                    ],
                    color: currentState == SalesState.closed
                        ? const Color.fromARGB(255, 210, 210, 210)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      getButtonText(),
                      style: TextStyle(
                        color: currentState == SalesState.selling
                            ? const Color.fromARGB(255, 186, 85, 28)
                            : currentState == SalesState.paused
                                ? const Color.fromARGB(255, 57, 124, 57)
                                : const Color.fromARGB(255, 120, 120, 120),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                // 오른쪽 하단 버튼
                onTap: closeSales,
                child: Container(
                  height: 70,
                  width: 150,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                        color: Colors.black.withOpacity(0.4),
                      )
                    ],
                    color: currentState == SalesState.closed
                        ? const Color.fromARGB(255, 210, 210, 210)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      '판매 마감',
                      style: TextStyle(
                        color: currentState == SalesState.closed
                            ? const Color.fromARGB(255, 120, 120, 120)
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
