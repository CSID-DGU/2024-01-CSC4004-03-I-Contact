import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Screen/Main/login_page.dart';
import 'package:leftover_is_over_owner/Screen/Search/search_PW_page.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';

class ChangePwComplete extends StatefulWidget {
  const ChangePwComplete({super.key});

  @override
  State<ChangePwComplete> createState() => _ChangePwCompleteState();
}

class _ChangePwCompleteState extends State<ChangePwComplete> {
  bool checkpassword = false;

  late TextEditingController controllerPwd, controllerPwdChk;

  @override
  void initState() {
    controllerPwd = TextEditingController();
    controllerPwdChk = TextEditingController();
  }

  void _checkCredentials() {
    var message = '에러';

    checkpassword = controllerPwd.text == controllerPwdChk.text;
    print('비밀번호 일치 검사 결과: $checkpassword');
    if (controllerPwd.text.isEmpty) {
      message = '비밀번호를 입력해주세요.';
    } else if (controllerPwdChk.text.isEmpty) {
      message = '비밀번호를 확인해주세요.';
    } else if (checkpassword) {
      message = '비밀번호 변경이 완료되었습니다.';
      var pwd = controllerPwd.text;
      /*Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StoreRegisterPage(password: pwd)),
      );*/
      return;
    }
    showErrorDialog(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 198, 88),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Text(
                'Loio',
                style: TextStyle(
                  fontSize: 50,
                  color: Color.fromARGB(255, 82, 59, 42),
                  fontFamily: "Logo",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Password 변경하기 ',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Free2",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 300,
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
                      controller: controllerPwd,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                            '비밀번호 확인',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 300,
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
                      controller: controllerPwdChk,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Column(
                      children: [
                        const Text(
                          '로그인을 다시 시도해주세요',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Free2",
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SearchPwPage()));
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Password 찾기'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Center(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: SizedBox(
                width: 300.0,
                height: 60.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 173, 190, 122)),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    '로그인 화면으로 이동',
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "MainButton",
                      fontSize: 17,
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