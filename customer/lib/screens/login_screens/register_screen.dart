import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leftover_is_over_customer/Services/auth_services.dart';
import 'package:leftover_is_over_customer/widgets/show_custom_dialog_widget.dart';
import 'package:leftover_is_over_customer/screens/login_screens/register_complete_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool checkduplicate = false;
  bool checkpassword = false;
  bool checkregister = false; // 가입하기 위한 조건. 아이디 중복 안되고 비밀번호 같아야함
  String lastCheckedId = '';

  late TextEditingController controllerName,
      controllerUsername,
      controllerEmail,
      controllerPhone,
      controllerPwd,
      controllerPwdChk;
  @override
  void initState() {
    controllerName = TextEditingController();
    controllerUsername = TextEditingController();
    controllerEmail = TextEditingController();
    controllerPhone = TextEditingController();
    controllerPwd = TextEditingController();
    controllerPwdChk = TextEditingController();
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

    // 이메일 형식을 확인하기 위한 정규 표현식
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$';
    RegExp regExp = RegExp(pattern);

    checkpassword = controllerPwd.text == controllerPwdChk.text;
    print('아이디 중복 검사 결과: $checkduplicate');
    print('비밀번호 일치 검사 결과: $checkpassword');
    if (controllerName.text.isEmpty) {
      message = '이름을 입력해주세요.';
    } else if (controllerUsername.text.isEmpty) {
      message = '아이디를 입력해주세요.';
    } else if (controllerEmail.text.isEmpty) {
      message = '이메일를 입력해주세요.';
    } else if (!regExp.hasMatch(controllerEmail.text)) {
      message = '올바른 이메일을 입력해주세요.';
    } else if (controllerPhone.text.isEmpty) {
      message = '전화번호를 입력해주세요.';
    } else if (controllerPhone.text.length < 11) {
      message = '올바른 전화번호를 입력해주세요.';
    } else if (controllerPwd.text.isEmpty) {
      message = '비밀번호를 입력해주세요.';
    } else if (controllerPwdChk.text.isEmpty) {
      message = '비밀번호를 확인해주세요.';
    } else if (checkpassword && checkduplicate) {
      if (lastCheckedId != controllerUsername.text) {
        // lastCheckedId와 실제 제출된 값이 다른 경우 중복확인을 새로 하도록 오류메세지
        message = '아이디 중복확인을 다시 해주세요.';
        setState(() {
          checkduplicate = false;
        });
      } else {
        var id = controllerUsername.text;
        var name = controllerName.text;
        var email = controllerEmail.text;
        var phone = controllerPhone.text;
        var pwd = controllerPwd.text;
        var registerCheck = await AuthService.register(
          username: id,
          name: name,
          email: email,
          phone: phone,
          password: pwd,
        );
        if (registerCheck) {
          // 회원가입 성공 시
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RegisterCompletePage()), //
          );
        }
        /*var id = controllerUsername.text;
        var name = controllerName.text;
        var email = controllerEmail.text;
        var phone = controllerPhone.text;
        var pwd = controllerPwd.text;*/

        return;
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Colors.black,
          elevation: 1,
          backgroundColor: Colors.white,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '회원가입  ',
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
                    color: const Color.fromARGB(255, 255, 231, 168),
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
                        color: const Color.fromARGB(255, 255, 231, 168),
                      ),
                      child: const Text(
                        '아이디',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    checkduplicate
                        ? Text(
                            '사용 가능   ',
                            style: TextStyle(
                                color: Colors.green[700], fontSize: 13),
                          )
                        : Text(
                            '사용 불가   ',
                            style:
                                TextStyle(color: Colors.red[700], fontSize: 13),
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
                    controller: controllerUsername,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _checkDuplicate(controllerUsername.text);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
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
                const SizedBox(
                  height: 5,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 255, 231, 168),
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
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(70),
                  ),
                  // 유효성 검증을 위해 TextFormFeild를 사용하라는데 TextFeild로도 작동하긴 함
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    autofocus: false,
                    controller: controllerEmail,
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
                    color: const Color.fromARGB(255, 255, 231, 168),
                  ),
                  child: const Text(
                    '전화번호',
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
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 255, 231, 168),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 255, 231, 168),
                  ),
                  child: const Text(
                    '비밀번호 확인',
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
                    obscureText: true,
                    autofocus: false,
                    controller: controllerPwdChk,
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
                        _checkCredentials();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 225, 116),
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
