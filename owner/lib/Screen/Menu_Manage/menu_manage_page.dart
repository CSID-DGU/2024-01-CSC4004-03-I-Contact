import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Services/menu_services.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_add.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_edit.dart';

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

  void refreshMenuList() {
    setState(() {
      menuList = MenuService.getMenuList(); // 메뉴 리스트 다시 불러오기
    });
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

  void openSales() {
    // 매장 현재 상태 오픈으로 변경하는 함수
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
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MenuMangeAddPage(),
                                  ),
                                );
                                refreshMenuList(); // 메뉴 리스트 갱신
                              },
                              icon: const Icon(
                                Icons.add_circle_outline_outlined,
                                size: 60,
                                color: Color.fromARGB(255, 120, 120, 120),
                              ),
                            ),
                          );
                        } else {
                          var menu = snapshot.data![index];
                          return Column(
                            children: [
                              MenuCard(
                                menu,
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
                              refreshMenuList();
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
                }
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

// 메뉴카드 생성 위젯
class MenuCard extends StatefulWidget {
  final MenuModel menu;

  const MenuCard(
    this.menu, {
    super.key,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  late String menuName;
  late int salesCost;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = '0'; // 초기값 설정'
    menuName = widget.menu.name;
    salesCost = widget.menu.sellPrice;
  }

  // 증가 버튼으로 숫자 증가 함수
  void _increment() {
    setState(() {
      if (_controller.text.isEmpty) {
        _controller.text = "0";
      } else {
        int currentValue = int.parse(_controller.text);

        _controller.text = (currentValue + 1).toString();
      }
    });
  }

  // 감소 버튼으로 숫자 감소 함수
  void _decrement() {
    setState(() {
      if (_controller.text.isEmpty) {
        _controller.text = "0";
      } else {
        int currentValue = int.parse(_controller.text);
        if (currentValue > 0) {
          _controller.text = (currentValue - 1).toString();
        }
      }
    });
  }

  // 숫자가 아닌 값 입력될 경우 0 처리 함수
  void _handleInputChange(String value) {
    if (value.isEmpty) {
      _controller.text = "";
    } else if (int.tryParse(value) == null) {
      _controller.text = "";
    } else {
      // 숫자가 유효한 경우, 그대로 둠
      _controller.text = value;
    }

    // 커서를 텍스트 끝으로 이동
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 150,
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
                                      color: Color.fromARGB(255, 222, 234, 187),
                                      width: 3),
                                  bottom: BorderSide(
                                      color: Color.fromARGB(255, 222, 234, 187),
                                      width: 3))),
                          child: Text(
                            menuName,
                            style: const TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(10, -10),
                          child: IconButton(
                            icon: const Icon(Icons.settings_outlined),
                            onPressed: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MenuManageEditPage(widget.menu)));
                              setState(() {
                                menuName = widget.menu.name;
                                salesCost = widget.menu.sellPrice;
                              });
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
                                fontWeight: FontWeight.w600,
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
                                    controller: _controller,
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
    );
  }
}