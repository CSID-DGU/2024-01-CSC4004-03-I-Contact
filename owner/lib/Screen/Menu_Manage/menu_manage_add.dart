import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Screen/Main/main_page.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_page.dart';
import 'package:leftover_is_over_owner/Services/menu_services.dart';
import 'package:leftover_is_over_owner/Services/store_services.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';

// 현재 틀만 만들어진 상태 기능 구현 필요

class MenuMangeAddPage extends StatefulWidget {
  final VoidCallback changeStoreState;
  const MenuMangeAddPage(this.changeStoreState, {super.key});
  @override
  State<MenuMangeAddPage> createState() => _MenuMangeAddPageState();
}

class _MenuMangeAddPageState extends State<MenuMangeAddPage> {
  late TextEditingController controllerName,
      controllerFirstPrice,
      controllerSellPrice;
  late bool isOpen;
  @override
  void initState() {
    // TODO: implement initState
    controllerName = TextEditingController();
    controllerFirstPrice = TextEditingController();
    controllerSellPrice = TextEditingController();
    loadStoreState();
  }

  loadStoreState() async {
    isOpen = await StoreService.getStoreState();
  }

  void _addMenu() async {
    var name = controllerName.text;
    var firstPrice = int.parse(controllerFirstPrice.text);
    var sellPrice = int.parse(controllerSellPrice.text);

    var addMenu = await MenuService.addMenu(
      name: name,
      firstPrice: firstPrice,
      sellPrice: sellPrice,
    );
    if (addMenu) {
      if (mounted) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
            (route) => false,
          );

          Future.delayed(Duration.zero, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuManagePage(
                        isOpen: isOpen,
                        changeStoreState: () => widget.changeStoreState(),
                      )),
            );
          });
        }
      }
    } else {
      var message = '메뉴 등록에 실패했습니다';
      if (mounted) {
        showErrorDialog(context, message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 1,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '메뉴 등록  ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '등록할 메뉴의 정보를 입력해주세요',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 222, 234, 187),
                  ),
                  child: const Text(
                    '메뉴 이름',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  height: 36,
                  width: 400,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    autofocus: true,
                    controller: controllerName, // 컨트롤러 예제에서는 주석 처리
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 23),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 222, 234, 187),
                      ),
                      child: const Text(
                        '원가',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  height: 36,
                  width: 400,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    autofocus: true,
                    controller: controllerFirstPrice, // 컨트롤러 예제에서는 주석 처리
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 222, 234, 187),
                  ),
                  child: const Text(
                    '할인가',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  height: 36,
                  width: 400,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    autofocus: true,
                    controller: controllerSellPrice, // 컨트롤러 예제에서는 주석 처리
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 130,
                      height: 70,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 3),
                            )
                          ],
                          color: const Color.fromARGB(255, 210, 210, 210),
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text(
                        '사진 등록하기',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 240, 240, 240),
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: _addMenu,
                        style: OutlinedButton.styleFrom(
                          shadowColor: Colors.black,
                          elevation: 2,
                          backgroundColor:
                              const Color.fromARGB(255, 222, 234, 187),
                          minimumSize: const Size(120, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 222, 234, 187)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          '등록하기',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
