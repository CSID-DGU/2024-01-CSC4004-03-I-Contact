import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Services/menu_services.dart';
import 'package:leftover_is_over_owner/Widget/sales_card_widget.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';

class SalesManagePage extends StatefulWidget {
  const SalesManagePage({super.key});

  @override
  State<SalesManagePage> createState() => SalesManagePageState();
}

class SalesManagePageState extends State<SalesManagePage> {
  StoreState currentState = StoreState.selling;
  StoreState? lastState;

  Future<List<MenuModel>> visibleMenuList = MenuService.getVisibleMenuList();

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

  String statusMessage() {
    // 현재 상태 출력
    switch (currentState) {
      case StoreState.selling:
        return '판매 중';
      case StoreState.paused:
        return '일시 중단';
      case StoreState.closed:
        return '마감';
    }
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
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ShowSalesStatus(
                // 매장 현재상태 보여주는 위젯
                statusMessage: statusMessage(),
                currentState: currentState,
              ),
              FutureBuilder(
                  future: visibleMenuList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.separated(
                          shrinkWrap: true, // 스크롤 뷰 내에서 사용될 때 크기를 조정함
                          physics:
                              const NeverScrollableScrollPhysics(), // ListView 자체 스크롤을 비활성화
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length, // 추가 버튼을 위해 +1
                          itemBuilder: (context, index) {
                            var menu = snapshot.data![index];
                            return SalesCard(
                                menuName: menu.name,
                                remainderNum: menu.capacity);
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Text(
                            '메뉴를 등록해주세요',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                        );
                      }
                    } else {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
        bottomNavigationBar: Container(
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
                    color: currentState == StoreState.closed
                        ? const Color.fromARGB(255, 210, 210, 210)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      getButtonText(),
                      style: TextStyle(
                        color: currentState == StoreState.selling
                            ? const Color.fromARGB(255, 186, 85, 28)
                            : currentState == StoreState.paused
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
                    color: currentState == StoreState.closed
                        ? const Color.fromARGB(255, 210, 210, 210)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      '판매 마감',
                      style: TextStyle(
                        color: currentState == StoreState.closed
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
