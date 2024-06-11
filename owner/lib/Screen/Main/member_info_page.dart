import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:leftover_is_over_owner/Model/user_model.dart';
import 'package:leftover_is_over_owner/Services/auth_services.dart';
import 'package:leftover_is_over_owner/Services/store_services.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';

class MemberInfoPage extends StatefulWidget {
  const MemberInfoPage({super.key});

  @override
  State<MemberInfoPage> createState() => _MemberInfoPageState();
}

class _MemberInfoPageState extends State<MemberInfoPage> {
  late UserModel user;
  late TextEditingController controllerName,
      controllerUsername,
      controllerEmail,
      controllerPhone,
      controllerPwd,
      controllerPwdChk;
  bool isLoading = true;
  bool readMode = true;
  bool checkpassword = false;
  String lastCheckedId = "";
  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController();
    controllerUsername = TextEditingController();
    controllerEmail = TextEditingController();
    controllerPhone = TextEditingController();
    controllerPwd = TextEditingController();
    controllerPwdChk = TextEditingController();
    _loadClient();
  }

  void _loadClient() async {
    user = await StoreService.getUserInfo();
    setState(() {
      isLoading = false;
      controllerName.text = user.name;
      controllerUsername.text = user.username;
      controllerEmail.text = user.email;
      controllerPhone.text = user.phone;
    });
  }

  void _changeMode() {
    setState(() {
      readMode = !readMode;
    });
  }

  void _checkCredentials() async {
    var message = '에러';

// 이메일 형식을 확인하기 위한 정규 표현식
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$';
    RegExp regExp = RegExp(pattern);

    checkpassword = controllerPwd.text == controllerPwdChk.text;
    if (controllerName.text.isEmpty) {
      message = '이름을 입력해주세요.';
    } else if (controllerEmail.text.isEmpty) {
      message = '이메일를 입력해주세요.';
    } else if (!regExp.hasMatch(controllerEmail.text)) {
      message = '올바른 이메일을 입력해주세요.';
    } else if (controllerPhone.text.isEmpty) {
      message = '전화번호를 입력해주세요.';
    } else if (controllerPwd.text.isEmpty) {
      message = '비밀번호를 입력해주세요.';
    } else if (controllerPwdChk.text.isEmpty) {
      message = '비밀번호 확인을 입력해주세요.';
    } else if (checkpassword) {
      var name = controllerName.text;
      var email = controllerEmail.text;
      var password = controllerPwd.text;
      var phone = controllerPhone.text;
      var modify = await AuthService.memberModify(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      if (modify) {
        _changeMode();
        message = "회원정보가 변경되었습니다.";
        showMessageDialog(context, message);
      } else {
        showErrorDialog(context, "회원정보 변경에 실패했습니다.");
      }
      return;
    } else {
      message = "비밀번호가 일치하지 않습니다.";
    }
    showErrorDialog(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '회원정보  ',
              style: TextStyle(
                fontSize: 24,
                fontFamily: "MainButton",
              ),
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
                  '회원 정보 로딩중..',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            )
          : Padding(
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
                        '이름',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]')), // 이름은 한글 또는 영어만 가능
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            '아이디',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
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
                        readOnly: true,
                        controller: controllerUsername,
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
                        color: const Color.fromARGB(255, 222, 234, 187),
                      ),
                      child: const Text(
                        '이메일',
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
                        controller: controllerEmail,
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
                        color: const Color.fromARGB(255, 222, 234, 187),
                      ),
                      child: const Text(
                        '전화번호',
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
                        controller: controllerPhone,
                        keyboardType: TextInputType.number,
                        // 입력값 숫자인지 확인
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                          // 전화번호 11자리까지 입력하도록함
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: !readMode,
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
                              '비밀번호',
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
                              obscureText: true,
                              autofocus: false,
                              controller: controllerPwd,
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
                              color: const Color.fromARGB(255, 222, 234, 187),
                            ),
                            child: const Text(
                              '비밀번호 확인',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "SubMenu",
                              ),
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
                              obscureText: true,
                              autofocus: false,
                              controller: controllerPwdChk,
                            ),
                          ),
                        ],
                      ),
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
                              readMode = !readMode;
                            } else {
                              _checkCredentials();
                              readMode = !readMode;
                            }
                            setState(() {}); // readMode 변경한 상태로 저장
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 222, 234, 187),
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
                              fontFamily: "Free2",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
