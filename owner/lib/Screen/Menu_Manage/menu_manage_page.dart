import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Provider/store_state.dart';
import 'package:leftover_is_over_owner/Services/menu_services.dart';
import 'package:leftover_is_over_owner/Services/store_services.dart';
import 'package:leftover_is_over_owner/Widget/menu_card_widget.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_add.dart';
import 'package:provider/provider.dart';

class MenuManagePage extends StatefulWidget {
  final bool isOpen;
  final VoidCallback changeStoreState;
  const MenuManagePage(
      {required this.isOpen, required this.changeStoreState, super.key});
  @override
  State<MenuManagePage> createState() => MenuManagePageState();
}

class MenuManagePageState extends State<MenuManagePage> {
  // 버튼 시연을 위해 현재상태 defalt값을 마감으로 설정함
  late bool isOpen; // widget.isOpen이랑 합체

  Future<List<MenuModel>> menuList = MenuService.getMenuList();
  Map<int, TextEditingController> controllers = {};
  Map<int, bool> selectedMenuItems = {};

  List<String> getAllText() {
    return controllers.values.map((controller) => controller.text).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    isOpen = widget.isOpen;
    menuList = MenuService.getMenuList();
    var storeState = Provider.of<StoreState>(context, listen: false);
    storeState.setRefreshCallback(refreshMenuList);
  }

  void refreshMenuList() {
    setState(() {
      menuList = MenuService.getMenuList();
    });
  }

  void changeButtonState() async {
    widget.changeStoreState();
    var storeState = context.read<StoreState>();
    if (!storeState.isOpen) {
      // 마감에서 판매 게시로 바뀔때
      storeState.openStore();
      List<Future> futures = [];
      controllers.forEach((foodId, controller) {
        bool visible = selectedMenuItems[foodId] ?? false;
        futures.add(MenuService.setMenu(
            foodId: foodId, capacity: controller.text, visible: visible));
      });
      await Future.wait(futures);
      refreshMenuList();
    } else {
      // 판매 게시에서 판매 마감으로 바뀔 때
      List<Future> futures = [];
      controllers.forEach((foodId, controller) {
        bool visible = false;
        controller.text = '0';
        futures.add(MenuService.setMenu(
            foodId: foodId, capacity: controller.text = '0', visible: visible));
      });
      await Future.wait(futures);
      refreshMenuList();
    }
    setState(() {
      isOpen = !isOpen;
    });
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
              isOpen: isOpen,
            ),
            IgnorePointer(
              ignoring: isOpen, // 매장이 판매중이면 더 이상 수정할 수 없어
              child: FutureBuilder(
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
                                      builder: (context) => MenuMangeAddPage(
                                          () => widget.changeStoreState()),
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
                                  menu: menu,
                                  controller: controllers[menu.foodId]!,
                                  isSelected:
                                      selectedMenuItems[menu.foodId] ?? false,
                                  onSelected: () =>
                                      toggleSelection(menu.foodId),
                                  changeStoreState: () => widget
                                      .changeStoreState(), // call이 필요할수도 잇어
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
                                    builder: (context) => MenuMangeAddPage(
                                        () => widget.changeStoreState),
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
              onTap: changeButtonState,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    isOpen ? "판매 마감" : "판매 개시",
                    style: TextStyle(
                      color: isOpen
                          ? const Color.fromARGB(255, 207, 21, 21)
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
