import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Model/user_model.dart';
import 'package:leftover_is_over_owner/Model/store_model.dart';
import 'package:leftover_is_over_owner/Services/auth_services.dart';
import 'package:leftover_is_over_owner/Services/user_services.dart';
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
      controllerPwd,
      controllerPwdChk;
  bool isLoading = true;
  bool readMode = true;
  bool checkpassword = false;
  bool checkduplicate = false;
  String lastCheckedId = "";
  @override
  void initState() {
    controllerName = TextEditingController();
    controllerUsername = TextEditingController();
    controllerEmail = TextEditingController();
    controllerPwd = TextEditingController();
    controllerPwdChk = TextEditingController();
    _loadClient();
  }

  void _loadClient() async {
    user = await UserService.getUserInfo();
    setState(() {
      isLoading = false;
      controllerName.text = user.name;
      controllerUsername.text = user.username;
      controllerEmail.text = user.email;
    });
  }

  void _changeMode() {
    setState(() {
      readMode = !readMode;
    });
  }

  void _checkDuplicate(String id) async {
    print(id);
    checkduplicate = await AuthService.duplicate(id);
    if (checkduplicate) {
      // 중복 검사를 통과한 경우
      lastCheckedId = id; // 마지막 중복 검사를 통과한 id를 lastCheckedId에 저장
    }
    setState(() {});
  }

  void _checkCredentials() async {
    var message = '에러';
    checkpassword = controllerPwd.text == controllerPwdChk.text;
    print('아이디 중복 검사 결과: $checkduplicate');
    print('비밀번호 일치 검사 결과: $checkpassword');
    if (controllerName.text.isEmpty) {
      message = '이름을 입력해주세요.';
    } else if (controllerUsername.text.isEmpty) {
      message = '아이디를 입력해주세요.';
    } else if (controllerEmail.text.isEmpty) {
      message = '이메일를 입력해주세요.';
    } else if (controllerPwd.text.isEmpty) {
      message = '비밀번호를 입력해주세요.';
    } else if (controllerPwdChk.text.isEmpty) {
      message = '비밀번호 확인을 입력해주세요.';
    } else if (checkpassword && checkduplicate) {
      if (lastCheckedId != controllerUsername.text) {
        // lastCheckedId와 실제 제출된 값이 다른 경우 중복확인을 새로 하도록 오류메세지
        message = '아이디 중복확인을 새로 해주세요.';
        setState(() {
          checkduplicate = false;
        });
      } else {
        var username = controllerUsername.text;
        var name = controllerName.text;
        var email = controllerEmail.text;
        var password = controllerPwd.text;
        var modify = await AuthService.memberModify(
          username: username,
          name: name,
          email: email,
          password: password,
        );
        if (modify) {
          _changeMode();
        }
      }
    } else if (checkduplicate) {
      message = '비밀번호가 일치하지 않습니다.';
    } else {
      message = '아이디 중복 확인을 해주세요.';
    }
    showErrorDialog(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원 정보"),
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
                  '이름',
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
                  readOnly: readMode,
                  controller: controllerName, // 컨트롤러 예제에서는 주석 처리
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green[300]!.withOpacity(0.6),
                    ),
                    child: const Text(
                      '아이디',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  checkduplicate
                      ? Visibility(
                          visible: !readMode,
                          child: Text(
                            '사용 가능   ',
                            style: TextStyle(
                                color: Colors.green[700], fontSize: 13),
                          ),
                        )
                      : Visibility(
                          visible: !readMode,
                          child: Text(
                            '사용 불가   ',
                            style:
                                TextStyle(color: Colors.red[700], fontSize: 13),
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
                  readOnly: readMode,
                  controller: controllerUsername,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Visibility(
                visible: !readMode,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _checkDuplicate(controllerUsername.text);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(color: Colors.grey[700]!),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      child: const Text(
                        '중복 확인',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                  '이메일',
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
                  controller: controllerEmail,
                ),
              ),
              const SizedBox(
                height: 35,
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
                  '비밀번호',
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
                  obscureText: true,
                  autofocus: true,
                  readOnly: readMode,
                  controller: controllerPwd,
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
                        color: Colors.green[300]!.withOpacity(0.6),
                      ),
                      child: const Text(
                        '비밀번호 확인',
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
                        obscureText: true,
                        autofocus: true,
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
    );
  }
}
