import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      controllerStorePhone,
      controllerBusinessNum;
  String selectedValue = '업종 선택';

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
    } else if (controllerBusinessNum.text.isEmpty) {
      message = '사업자 등록 번호를 입력해주세요.';
      showDialogRegister(message);
      return;
    } else {
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
        showDialogRegister(message);
        message = '유효한 시간을 입력해주세요';
        return;
      }
    }

    var registerCheck = await ApiService.register(
        widget.username, widget.name, widget.email, widget.password);
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
      var businessNum = controllerBusinessNum.text;

      var registerCheck = await ApiService.register(
          widget.username, widget.name, widget.email, widget.password);

      var registerStoreCheck = await ApiService.storeRegister(
          storeName: storeName,
          startTime: startTime,
          endTime: endTime,
          address: address,
          storePhone: storePhone,
          businessNum: businessNum);

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
    controllerBusinessNum = TextEditingController();
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
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[300]!.withOpacity(0.6),
                  ),
                  child: const Text(
                    '매장 이름',
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[300]!.withOpacity(0.6),
                  ),
                  child: const Text(
                    '업종 분류',
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
                        '    업종을 선택해주세요',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700]),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (String value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('선택된 값: $value')));
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: '한식',
                            child: Text('한식'),
                          ),
                          const PopupMenuItem<String>(
                            value: '양식',
                            child: Text('양식'),
                          ),
                          const PopupMenuItem<String>(
                            value: '일식',
                            child: Text('일식'),
                          ),
                          const PopupMenuItem<String>(
                            value: '중식',
                            child: Text('중식'),
                          ),
                          // 추가 메뉴 아이템들...
                        ],
                      ),
                    ],
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
                    color: Colors.green[300]!.withOpacity(0.6),
                  ),
                  child: const Text(
                    '주소',
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[300]!.withOpacity(0.6),
                  ),
                  child: const Text(
                    '매장 전화 번호',
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[300]!.withOpacity(0.6),
                  ),
                  child: const Text(
                    '사업자 등록 번호',
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
                    controller: controllerBusinessNum,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // 중복 확인 로직
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.green[300]!.withOpacity(0.6),
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
      ),
    );
  }
}
