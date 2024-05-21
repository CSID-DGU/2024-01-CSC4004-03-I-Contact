import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Screen/login_page.dart';
import 'package:leftover_is_over_owner/Screen/register_complete_page.dart';
import 'package:leftover_is_over_owner/Screen/register_page.dart';
import 'package:leftover_is_over_owner/Screen/test.dart';
import 'package:leftover_is_over_owner/Services/api_services.dart';

class StoreRegisterPage extends StatefulWidget {
  final String username, name, email, password;
  const StoreRegisterPage(this.username, this.name, this.email, this.password,
      {super.key});
  @override
  State<StoreRegisterPage> createState() => _StoreRegisterPageState();
}

class _StoreRegisterPageState extends State<StoreRegisterPage> {
  late TextEditingController controllerName,
      controllerStartTimeHour,
      controllerStartTimeMin,
      controllerEndTimeHour,
      controllerEndTimeMin,
      controllerAddress,
      controllerDetailAddress,
      controllerStorePhone;
  String category = '업종을 선택해주세요';
  late int categoryId;
  bool _isDropdownVisible = false;
  double _opacity = 0.0;

  final List<String> categoryLabels = [
    '한식',
    '중식',
    '일식',
    '양식',
    '아시안',
    '분식',
    '디저트',
    '도시락',
    '기타'
  ];

  void _categoryDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
      _opacity = _isDropdownVisible ? 0.95 : 0.0;
    });
  }

  void showDialogRegister(String message) {
    var errorMessage = message;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(
            errorMessage,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화상자 닫기
              },
            ),
          ],
        );
      },
    );
  }

  void testButton() async {
    var registerCheck = await ApiService.register(
      username: widget.username,
      name: widget.name,
      email: widget.email,
      password: widget.password,
    );
    if (registerCheck) {
      // 회원가입 성공 시
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RegisterCompletePage()), //
      );
    }
  }

  void checkValidTime() {
    try {
      int startTimeHour = int.parse(controllerStartTimeHour.text);
      int startTimeMin = int.parse(controllerStartTimeMin.text);
      int endTimeHour = int.parse(controllerEndTimeHour.text);
      int endTimeMin = int.parse(controllerEndTimeMin.text);
      if (startTimeHour < 0 ||
          startTimeHour > 24 ||
          endTimeHour < 0 ||
          endTimeHour > 24 ||
          startTimeMin < 0 ||
          startTimeMin > 60 ||
          endTimeMin < 0 ||
          endTimeMin > 60) {
        throw Error();
      } else {
        // 마감시간이 오픈시간보다 뒤어야함
        var validCheck =
            endTimeHour * 60 + endTimeMin - startTimeHour * 60 + startTimeMin;
        if (validCheck < 0) {
          throw Error();
        }
      }
      if (controllerStartTimeHour.text.length == 1) {
        controllerStartTimeHour.text = '0${controllerStartTimeHour.text}';
      } else if (controllerStartTimeMin.text.length == 1) {
        controllerStartTimeMin.text = '0${controllerStartTimeMin.text}';
      } else if (controllerEndTimeHour.text.length == 1) {
        controllerEndTimeHour.text = '0${controllerEndTimeHour.text}';
      } else if (controllerEndTimeMin.text.length == 1) {
        controllerEndTimeMin.text = '0${controllerEndTimeMin.text}';
      }
    } catch (e) {
      var message = '유효한 시간을 입력해주세요';
      showDialogRegister(message);
      return;
    }
  }

  void checkCredentials() async {
    var message = '에러';
    if (controllerName.text.isEmpty) {
      message = '매장 이름을 입력해주세요.';
      showDialogRegister(message);
      return;
    } else if (controllerStartTimeHour.text.isEmpty ||
        controllerStartTimeMin.text.isEmpty) {
      message = '오픈 시간을 입력해주세요.';
      showDialogRegister(message);
      return;
    } else if (controllerEndTimeMin.text.isEmpty ||
        controllerEndTimeMin.text.isEmpty) {
      message = '마감 시간을 입력해주세요.';
      showDialogRegister(message);
      return;
    } else if (controllerAddress.text.isEmpty ||
        controllerDetailAddress.text.isEmpty) {
      message = '주소를 입력해주세요.';
      showDialogRegister(message);
      return;
    } else if (controllerStorePhone.text.isEmpty) {
      message = '가게 전화 번호를 입력해주세요.';
      showDialogRegister(message);
      return;
    } else if (category.isEmpty) {
      message = '음식점 카테고리를 선택해주세요';
      showDialogRegister(message);
      return;
    } else {
      checkValidTime();
    }

    var registerCheck = await ApiService.register(
      username: widget.username,
      name: widget.name,
      email: widget.email,
      password: widget.password,
    );

    if (registerCheck) {
      // 회원가입 완료 되었을 시
      var storeName = controllerName.text;
      var startTimeHour = controllerStartTimeHour.text;
      var startTimeMin = controllerStartTimeMin.text;
      var startTime = '$startTimeHour:$startTimeMin';
      var endTimeHour = controllerEndTimeHour.text;
      var endTimeMin = controllerEndTimeMin.text;
      var endTime = '$endTimeHour:$endTimeMin';
      var address = controllerAddress.text;
      var storePhone = controllerStorePhone.text;
      // var category = categoryLabels.elementAt(index)
      var registerStoreCheck = await ApiService.storeRegister(
        userName: widget.username,
        storeName: storeName,
        startTime: startTime,
        endTime: endTime,
        address: address,
        storePhone: storePhone,
        categoryId: categoryId,
      );

      if (registerCheck && registerStoreCheck) {
        // 회원가입 성공 시
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const RegisterCompletePage()), //
        );
      }
    }

    {}
  }

  @override
  void initState() {
    controllerName = TextEditingController();
    controllerStartTimeHour = TextEditingController();
    controllerStartTimeMin = TextEditingController();
    controllerEndTimeHour = TextEditingController();
    controllerEndTimeMin = TextEditingController();
    controllerAddress = TextEditingController();
    controllerDetailAddress = TextEditingController();
    controllerStorePhone = TextEditingController();
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
          backgroundColor: Colors.amber[600],
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '가게 정보 등록  ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 23),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green[300]!.withOpacity(0.6),
                      ),
                      child: const Text(
                        '매장 이름',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
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
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(-2, 5),
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
                      height: 10,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              clipBehavior: Clip.hardEdge,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 23),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green[300]!.withOpacity(0.6),
                              ),
                              child: const Text(
                                '오픈 시간',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Container(
                          height: 36,
                          width: 67,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(-2, 5),
                              )
                            ],
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            autofocus: true,
                            controller: controllerStartTimeHour,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        const Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              ':',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 36,
                          width: 67,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(-2, 5),
                              )
                            ],
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            autofocus: true,
                            controller: controllerStartTimeMin,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              clipBehavior: Clip.hardEdge,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 23),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green[300]!.withOpacity(0.6),
                              ),
                              child: const Text(
                                '마감 시간',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Container(
                          height: 36,
                          width: 67,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(-2, 5),
                              )
                            ],
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            autofocus: true,
                            controller: controllerEndTimeHour,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        const Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              ':',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 36,
                          width: 67,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(-2, 5),
                              )
                            ],
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            autofocus: true,
                            controller: controllerEndTimeMin,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 23),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green[300]!.withOpacity(0.6),
                      ),
                      child: const Text(
                        '업종 분류',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
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
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(-2, 5),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '    $category',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700]),
                          ),
                          Transform.rotate(
                            angle: 270 * 3.141592 / 180,
                            child: IconButton(
                              onPressed: () {
                                _categoryDropdown();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new_outlined,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 23),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green[300]!.withOpacity(0.6),
                      ),
                      child: const Text(
                        '주소',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
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
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(-2, 5),
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
                        controller: controllerAddress,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 36,
                      width: 400,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(-2, 5),
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
                        controller: controllerDetailAddress,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 23),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green[300]!.withOpacity(0.6),
                      ),
                      child: const Text(
                        '매장 전화 번호',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
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
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(-2, 5),
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
                        controller: controllerStorePhone,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 23),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green[300]!.withOpacity(0.6),
                      ),
                      child: const Text(
                        '사업자 등록 번호',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            checkCredentials();
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                Colors.green[300]!.withOpacity(0.6),
                            minimumSize: const Size(120, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(color: Colors.grey[200]!),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            '다음',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Visibility(
                visible: _isDropdownVisible,
                child: Positioned(
                  top:
                      287, // Adjust this to place the dropdown in the correct position
                  left:
                      32, // Adjust this to place the dropdown in the correct position
                  right:
                      32, // Adjust this to place the dropdown in the correct position
                  bottom:
                      180, // Adjust this to place the dropdown in the correct position

                  child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      color: const Color.fromARGB(255, 235, 230, 230),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isDropdownVisible,
              child: Positioned(
                top:
                    293, // Adjust this to place the dropdown in the correct position
                left:
                    32, // Adjust this to place the dropdown in the correct position
                right:
                    32, // Adjust this to place the dropdown in the correct position
                bottom:
                    180, // Adjust this to place the dropdown in the correct position

                child: Padding(
                  // Padding 시작
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: categoryLabels.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            category = categoryLabels[index];
                            categoryId = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.black,
                          elevation: 5,
                        ),
                        child: Text(
                          categoryLabels[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  ),
                ), // Padding 끝
              ),
            )
          ],
        ),
      ),
    );
  }
}
