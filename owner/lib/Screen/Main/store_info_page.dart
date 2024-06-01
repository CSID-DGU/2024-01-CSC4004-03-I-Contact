import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Model/store_model.dart';
import 'package:leftover_is_over_owner/Services/user_services.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';
import 'package:leftover_is_over_owner/Services/auth_services.dart';
import 'dart:ui';

class StoreInfoPage extends StatefulWidget {
  const StoreInfoPage({super.key});

  @override
  State<StoreInfoPage> createState() => _StoreInfoPageState();
}

class _StoreInfoPageState extends State<StoreInfoPage> {
  late StoreModel store;
  late TextEditingController controllerName,
      controllerStartTimeHour,
      controllerStartTimeMin,
      controllerEndTimeHour,
      controllerEndTimeMin,
      controllerAddress,
      controllerDetailAddress,
      controllerStorePhone;
  //controllerCategory;

  bool isLoading = true;
  bool readMode = true;
  String lastCheckedId = "";
  String category = '업종을 선택해주세요';
  late int categoryId;
  bool _isDropdownVisible = false;
  double _opacity = 0.0;

  final List<String> categoryLabels = [
    '한식',
    '중식',
    '일식',
    '양식',
    '패스트푸드',
    '아시안',
    '분식',
    '디저트',
    '기타'
  ];

  void _categoryDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
      _opacity = _isDropdownVisible ? 0.95 : 0.0;
    });
  }

  late List<String> storeStartTime = store.startTime.split(':');
  late String startHour = storeStartTime[0];
  late String startMinute = storeStartTime[1];
  late List<String> storeEndTime = store.endTime.split(':');
  late String endHour = storeEndTime[0];
  late String endMinute = storeEndTime[1];

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

  bool checkValidTime() {
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
      }
      if (controllerStartTimeMin.text.length == 1) {
        controllerStartTimeMin.text = '0${controllerStartTimeMin.text}';
      }
      if (controllerEndTimeHour.text.length == 1) {
        controllerEndTimeHour.text = '0${controllerEndTimeHour.text}';
      }
      if (controllerEndTimeMin.text.length == 1) {
        controllerEndTimeMin.text = '0${controllerEndTimeMin.text}';
      }
      return true;
    } catch (e) {
      var message = '유효한 시간을 입력해주세요';
      showErrorDialog(context, message);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController();
    controllerStartTimeHour = TextEditingController();
    controllerStartTimeMin = TextEditingController();
    controllerEndTimeHour = TextEditingController();
    controllerEndTimeMin = TextEditingController();
    controllerAddress = TextEditingController();
    controllerDetailAddress = TextEditingController();
    controllerStorePhone = TextEditingController();
    //controllerCategory = TextEditingController();
    _loadStore();
  }

  void _loadStore() async {
    store = await UserService.getStoreInfo();
    setState(() {
      isLoading = false;
      controllerName.text = store.name;

      // 변수 업데이트
      storeStartTime = store.startTime.split(':');
      startHour = storeStartTime[0];
      startMinute = storeStartTime[1];
      storeEndTime = store.endTime.split(':');
      endHour = storeEndTime[0];
      endMinute = storeEndTime[1];

      controllerStartTimeHour.text = startHour;
      controllerStartTimeMin.text = startMinute;
      controllerEndTimeHour.text = endHour;
      controllerEndTimeMin.text = endMinute;
      controllerAddress.text = store.address;
      controllerStorePhone.text = store.phone;
      //controllerCategory.text = categoryLabels[store.categoryId];
    });
  }

  void _changeMode() {
    setState(() {
      readMode = !readMode;
    });
  }

  void _checkCredentials() async {
    var message = '에러';
    if (controllerName.text.isEmpty) {
      message = '매장 이름을 입력해주세요.';
    } else if (controllerStartTimeHour.text.isEmpty) {
      message = '오픈시간(시)을 입력해주세요.';
    } else if (controllerStartTimeMin.text.isEmpty) {
      message = '오픈시간(분)을 입력해주세요.';
    } else if (controllerEndTimeHour.text.isEmpty) {
      message = '마감시간(시) 을 입력해주세요.';
    } else if (controllerEndTimeMin.text.isEmpty) {
      message = '마감시간(분) 을 입력해주세요.';
    } else if (category.isEmpty) {
      message = '매장 카테고리를 선택해주세요';
    } else if (controllerStorePhone.text.isEmpty) {
      message = '매장 전화번호를 입력해주세요';
    } else if (controllerStorePhone.text.length < 10) {
      message = '올바른 전화번호를 입력해주세요.';
    } else if (controllerAddress.text.isEmpty) {
      message = '주소를 입력해주세요.';
    } else if (checkValidTime()) {
      var name = controllerName.text;
      var startTimeHour = controllerStartTimeHour.text;
      var startTimeMin = controllerStartTimeMin.text;
      var startTime = '$startTimeHour:$startTimeMin';
      var endTimeHour = controllerEndTimeHour.text;
      var endTimeMin = controllerEndTimeMin.text;
      var endTime = '$endTimeHour:$endTimeMin';
      //var category = categoryLabels.elementAt(index)
      var adress = controllerAddress.text;
      var phone = controllerStorePhone.text;
      var modify = await AuthService.storeModify(
        name: name,
        startTime: startTime,
        endTime: endTime,
        adress: adress,
        phone: phone,
        categoryID: categoryId,
      );
      if (modify) {
        _changeMode();
      }
    }

    showErrorDialog(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black,
          elevation: 1,
          backgroundColor: Colors.white,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '매장정보  ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        body: isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '매장 정보 로딩중..',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
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
                                color: const Color.fromARGB(255, 222, 234, 187),
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
                                readOnly: readMode,
                                controller: controllerName, // 컨트롤러 예제에서는 주석 처리
                              ),
                            ),
                            const SizedBox(
                              height: 26,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.hardEdge,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 23),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color.fromARGB(
                                            255, 222, 234, 187),
                                      ),
                                      child: const Text(
                                        '오픈 시간',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
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
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.4),
                                        offset: const Offset(1, 3),
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
                                        borderRadius:
                                            BorderRadius.circular(70.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    autofocus: false,
                                    readOnly: readMode,
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
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.4),
                                        offset: const Offset(1, 3),
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
                                        borderRadius:
                                            BorderRadius.circular(70.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    autofocus: false,
                                    readOnly: readMode,
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
                                        color: const Color.fromARGB(
                                            255, 222, 234, 187),
                                      ),
                                      child: const Text(
                                        '마감 시간',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
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
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.4),
                                        offset: const Offset(1, 3),
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
                                        borderRadius:
                                            BorderRadius.circular(70.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    autofocus: false,
                                    readOnly: readMode,
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
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.4),
                                        offset: const Offset(1, 3),
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
                                        borderRadius:
                                            BorderRadius.circular(70.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    autofocus: false,
                                    readOnly: readMode,
                                    controller: controllerEndTimeMin,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 26,
                            ),
                            Container(
                              clipBehavior: Clip.hardEdge,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 23),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 222, 234, 187),
                              ),
                              child: const Text(
                                '업종분류',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
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
                                color: Colors.white,
                              ),
                              child: Text(
                                "    ${categoryLabels[store.categoryId]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              /*child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(70.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          autofocus: false,
                          readOnly: readMode,
                          controller: controllerCategory,
                        ),*/
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Visibility(
                              visible: !readMode,
                              child: Container(
                                height: 36,
                                width: 400,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.4),
                                      offset: const Offset(1, 3),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(70),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              // 주소 디테일 보류
                              clipBehavior: Clip.hardEdge,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 23),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 222, 234, 187),
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
                                readOnly: readMode,
                                controller: controllerAddress,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
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
                                color: const Color.fromARGB(255, 222, 234, 187),
                              ),
                              child: const Text(
                                '매장 전화번호',
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
                                readOnly: readMode,
                                controller: controllerStorePhone,
                                keyboardType: TextInputType.number,
                                // 입력값 숫자인지 확인
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(11),
                                  // 전화번호 11자리까지만 입력할 수 있음
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .end, // readMode냐 아니냐에 따른 기능 배분하기 !! 이어서 수정하기
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    if (readMode) {
                                      setState(() {
                                        readMode = !readMode;
                                      });
                                    } else {
                                      _checkCredentials();
                                      readMode = !readMode;
                                    }
                                    setState(() {}); // readMode 변경한 상태로 저장
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 222, 234, 187),
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
                                    '수정하기',
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
                    Visibility(
                      visible: !readMode && _isDropdownVisible,
                      child: Positioned(
                        top: 347,
                        left: 32,
                        right: 32,
                        bottom: 65,
                        child: AnimatedOpacity(
                          opacity: _opacity,
                          duration: const Duration(milliseconds: 300),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 5.0, sigmaY: 5.0), // 블러 효과 적용
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromARGB(255, 112, 120, 91)
                                      .withOpacity(0.75),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !readMode && _isDropdownVisible,
                      child: Positioned(
                        top: 357,
                        left: 32,
                        right: 32,
                        bottom: 70,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 14),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.7,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20,
                            ),
                            itemCount: categoryLabels.length,
                            itemBuilder: (context, index) {
                              return ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isDropdownVisible = false;
                                    category = categoryLabels[index];
                                    categoryId = index;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  shadowColor: Colors.black,
                                  elevation: 5,
                                ),
                                child: Text(categoryLabels[index],
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
