import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Screen/Main/main_page.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_page.dart';
import 'package:leftover_is_over_owner/Services/menu_services.dart';
import 'package:leftover_is_over_owner/Services/store_services.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';

// 현재 틀만 만들어진 상태 기능 구현 필요
// 메뉴 선택해서 수정 페이지로 넘어올 때 각 입력창에는 직전에 선택해서 넘어온
//메뉴의 정보가 회색으로 써있고 수정하고 싶은 정보만 선택적으로 수정할 수 있도록 해야함

class MenuManageEditPage extends StatefulWidget {
  final MenuModel menu;
  const MenuManageEditPage(this.menu, {super.key});

  @override
  State<MenuManageEditPage> createState() => _MenuManageEditPageState();
}

class _MenuManageEditPageState extends State<MenuManageEditPage> {
  late TextEditingController controllerName, controllerFP, controllerSP;
  late bool isOpen;
  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController();
    controllerFP = TextEditingController();
    controllerSP = TextEditingController();
    controllerName.text = widget.menu.name;
    controllerFP.text = widget.menu.firstPrice.toString();
    controllerSP.text = widget.menu.sellPrice.toString();
  }

  void _deleteMenu() async {
    var deleteMenu = await MenuService.deleteMenu(widget.menu.foodId);
    if (deleteMenu) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
          (route) => false,
        );

        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuManagePage()),
          );
        });
      }
    } else {
      var message = "메뉴 삭제에 실패했습니다";
      if (mounted) {
        showErrorDialog(context, message);
      }
    }
  }

  void _updateMenu() async {
    widget.menu.name = controllerName.text;
    widget.menu.firstPrice = int.parse(controllerFP.text);
    widget.menu.sellPrice = int.parse(controllerSP.text);
    var updatMenuInfo = await MenuService.updateMenuInfo(widget.menu);
    if (updatMenuInfo) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
          (route) => false,
        );

        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuManagePage()),
          );
        });
      }
    } else {
      var message = "메뉴 수정에 실패했습니다";
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
                '메뉴 설정  ',
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
                    '수정할 메뉴의 정보를 입력해주세요',
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
                    autofocus: false,
                    controller: controllerName,
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
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    controller: controllerFP,
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
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    controller: controllerSP,
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
                        '사진 수정하기',
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
                  padding: const EdgeInsets.only(top: 120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: _deleteMenu,
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
                          '삭제',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _updateMenu,
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
                          '수정',
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
