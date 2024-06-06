import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Screen/Main/main_page.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_edit.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_page.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';

// 메뉴카드 생성 위젯
class MenuCard extends StatefulWidget {
  final MenuModel menu;
  final TextEditingController controller;
  final bool isSelected;
  final VoidCallback onSelected;
  const MenuCard({
    required this.menu,
    required this.controller,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  late String menuName;
  late int salesCost;

  @override
  void initState() {
    super.initState();
    menuName = widget.menu.name;
    salesCost = widget.menu.sellPrice;
  }

  // 증가 버튼으로 숫자 증가 함수
  void _increment() {
    setState(() {
      if (widget.controller.text.isEmpty) {
        widget.controller.text = "0";
      } else {
        int currentValue = int.parse(widget.controller.text);

        widget.controller.text = (currentValue + 1).toString();
      }
    });
  }

  // 감소 버튼으로 숫자 감소 함수
  void _decrement() {
    setState(() {
      if (widget.controller.text.isEmpty) {
        widget.controller.text = "0";
      } else {
        int currentValue = int.parse(widget.controller.text);
        if (currentValue > 0) {
          widget.controller.text = (currentValue - 1).toString();
        }
      }
    });
  }

  // 숫자가 아닌 값 입력될 경우 0 처리 함수
  void _handleInputChange(String value) {
    if (value.isEmpty) {
      widget.controller.text = "";
    } else if (int.tryParse(value) == null) {
      widget.controller.text = "";
    } else {
      // 숫자가 유효한 경우, 그대로 둠
      widget.controller.text = value;
    }

    // 커서를 텍스트 끝으로 이동
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: widget.isSelected || widget.menu.visible
                      ? Colors.grey[100]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius:
                          widget.isSelected || widget.menu.visible ? 5 : 5,
                      color: widget.isSelected || widget.menu.visible
                          ? Colors.yellow.shade800
                          : Colors.black.withOpacity(0.3),
                      offset: widget.isSelected || widget.menu.visible
                          ? const Offset(0, 0)
                          : const Offset(0, 2),
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
                              menuName,
                              style: const TextStyle(
                                  fontSize: 23,
                                  fontFamily: "Free2",
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(10, -10),
                            child: IconButton(
                              icon: const Icon(Icons.settings_outlined),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MenuManageEditPage(
                                              widget.menu,
                                            )));
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '등록가격: $salesCost',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Free2",
                                  //fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 150,
                            height: 60,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 개수 감소 버튼
                                IconButton(
                                  onPressed: _decrement,
                                  icon: const Icon(
                                    Icons.remove_circle_outline_outlined,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                // 개수 입력창
                                Container(
                                  height: 30,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 1,
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 50,
                                      maxWidth: 100,
                                    ),
                                    child: TextField(
                                      controller: widget.controller,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(255, 217, 217, 217),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      // 입력값 숫자인지 확인
                                      onChanged: _handleInputChange,
                                      inputFormatters: [
                                        // 두 자릿수 숫자만 입력 가능하도록 제한
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                      textAlign: TextAlign.center, // 텍스트 중앙 정렬
                                    ),
                                  ),
                                ),
                                // 개수 증가 버튼
                                IconButton(
                                  onPressed: _increment,
                                  icon: const Icon(
                                    Icons.add_circle_outline_outlined,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
