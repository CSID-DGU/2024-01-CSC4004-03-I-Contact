import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Services/menu_services.dart';
import 'package:leftover_is_over_owner/Widget/menu_card_widget.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_add.dart';

class MenuManagePage extends StatefulWidget {
  final startState;
  const MenuManagePage(this.startState, {super.key});

  @override
  State<MenuManagePage> createState() => MenuManagePageState();
}

class MenuManagePageState extends State<MenuManagePage> {
  // 버튼 시연을 위해 현재상태 defalt값을 마감으로 설정함
  StoreState currentState = StoreState.closed;
  StoreState? lastState;

  Future<List<MenuModel>> menuList = MenuService.getMenuList();

  Map<int, TextEditingController> controllers = {};
  Map<int, bool> selectedMenuItems = {};

  List<String> getAllText() {
    return controllers.values.map((controller) => controller.text).toList();
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

  void openSales() async {
    print(getAllText());
    // 매장 현재 상태 오픈으로 변경하는 함수
    List<Future> futures = [];
    controllers.forEach((foodId, controller) {
      bool visible = selectedMenuItems[foodId]!;
      futures.add(MenuService.setMenu(
          foodId: foodId, capacity: controller.text, visible: visible));
    });
    await Future.wait(futures);
    setState(() {
      currentState = StoreState.selling;
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

  void toggleSelection(int menuId) {
    setState(() {
      selectedMenuItems[menuId] = !(selectedMenuItems[menuId] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // 키보드가 열릴 때 레이아웃을 재조정하지 않음
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '메뉴 관리  ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ShowSalesStatus(
              // 매장 현재상태 보여주는 위젯
              statusMessage: statusMessage(),
              currentState: currentState,
            ),
            FutureBuilder(
              future: menuList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true, // 스크롤 뷰 내에서 사용될 때 크기를 조정함
                      physics:
                          const NeverScrollableScrollPhysics(), // ListView 자체 스크롤을 비활성화
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length + 1, // 추가 버튼을 위해 +1
                      itemBuilder: (context, index) {
                        if (index == snapshot.data!.length) {
                          // 마지막 항목 다음에 추가 버튼을 넣음
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MenuMangeAddPage(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.add_circle_outline_outlined,
                                size: 60,
                                color: Color.fromARGB(255, 120, 120, 120),
                              ),
                            ),
                          );
                        } else {
                          if (controllers.isEmpty) {
                            controllers = {
                              for (var menu in snapshot.data!)
                                menu.foodId: TextEditingController(
                                    text: menu.capacity.toString())
                            };
                          }
                          var menu = snapshot.data![index];
                          return Column(
                            children: [
                              MenuCard(
                                menu,
                                controllers[menu.foodId]!,
                                selectedMenuItems[menu.foodId] ?? false,
                                onSelected: () => toggleSelection(menu.foodId),
                              ),
                              const SizedBox(height: 5), // 항목 사이에 간격 추가
                            ],
                          );
                        }
                      },
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        const Text(
                          '메뉴를 등록해주세요',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: IconButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MenuMangeAddPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add_circle_outline_outlined,
                              size: 60,
                              color: Color.fromARGB(255, 120, 120, 120),
                            ),
                          ),
                        ),
                      ],
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
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              // 판매 개시 버튼
              onTap: openSales,
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
                  color: currentState == StoreState.selling
                      ? const Color.fromARGB(255, 210, 210, 210)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    '판매 개시',
                    style: TextStyle(
                      color: currentState == StoreState.selling
                          ? const Color.fromARGB(255, 120, 120, 120)
                          : const Color.fromARGB(255, 57, 124, 57),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
