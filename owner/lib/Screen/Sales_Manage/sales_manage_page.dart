import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Provider/store_state.dart';
import 'package:leftover_is_over_owner/Services/menu_services.dart';
import 'package:leftover_is_over_owner/Widget/sales_card_widget.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';
import 'package:provider/provider.dart';

class SalesManagePage extends StatefulWidget {
  const SalesManagePage({super.key});
  @override
  State<SalesManagePage> createState() => SalesManagePageState();
}

class SalesManagePageState extends State<SalesManagePage> {
  Future<List<MenuModel>> visibleMenuList = MenuService.getVisibleMenuList();

  @override
  void initState() {
    super.initState();
    var storeState = Provider.of<StoreState>(context, listen: false);
    storeState.setRefreshSalesCallback(refreshMenuList);
  }

  void refreshMenuList() {
    setState(() {
      visibleMenuList = MenuService.getVisibleMenuList();
    });
  }

  void closeStoreState() async {
    var storeState = context.read<StoreState>();
    if (storeState.isOpen) {
      storeState.toggleStore();
    }
  }

  void updateMenuCapacity(int foodId, int remainder, bool add) async {
    await MenuService.updateMenuCapacity(foodId, remainder, add);
    refreshMenuList();
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
              Consumer<StoreState>(builder: (context, storeState, child) {
                return ShowSalesStatus(
                  // 매장 현재상태 보여주는 위젯
                  isOpen: storeState.isOpen,
                );
              }),
              Consumer<StoreState>(builder: (context, storeState, child) {
                return IgnorePointer(
                  ignoring: !storeState.isOpen, // 닫혀있으면 수정할 수 없어!!
                  child: FutureBuilder(
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
                                  foodId: menu.foodId,
                                  menuName: menu.name,
                                  remainderNum: menu.capacity,
                                  updateMenuCapacity: (add) =>
                                      updateMenuCapacity(
                                          menu.foodId, menu.capacity, add),
                                );
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
                      }),
                );
              })
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                // 오른쪽 하단 버튼
                onTap: closeStoreState,
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
                    color: !context.watch<StoreState>().isOpen
                        ? const Color.fromARGB(255, 210, 210, 210)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      '판매 마감',
                      style: TextStyle(
                        color: !context.watch<StoreState>().isOpen
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
