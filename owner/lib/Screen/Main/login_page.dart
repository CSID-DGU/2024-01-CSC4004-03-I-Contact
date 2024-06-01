import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:leftover_is_over_owner/Provider/store_state.dart';
import 'package:leftover_is_over_owner/Screen/Main/main_page.dart';
import 'package:leftover_is_over_owner/Screen/Register/register_page.dart';
import 'package:leftover_is_over_owner/Services/auth_services.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController controllerUsername, controllerPwd;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    controllerUsername = TextEditingController();
    controllerPwd = TextEditingController();
  }

  void _login() async {
    // 로그인 버튼이 눌릴 시 호출되는 함수
    setState(() {
      isLoading = true;
    });
    var login = await AuthService.login(
      username: controllerUsername.text,
      password: controllerPwd.text,
    );
    setState(() {
      isLoading = false;
    });
    if (login) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => StoreState(),
            child: const MainPage(),
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      if (!mounted) {
        return;
      }
      showErrorDialog(context, '아이디/Password를 확인해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 198, 88),
        /*appBar: AppBar(
          title: const Center(
            child: Text(
              '로그인 페이지',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),*/
        body: isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '로그인 중..',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min, // Column의 높이를 최소로 설정
                    children: [
                      const SizedBox(height: 70),
                      const CircleAvatar(
                        // Flexible 제거
                        backgroundColor: Colors.white,
                        radius: 100.0,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          '로그인',
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
                      Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'ID',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            autofocus: false,
                            controller: controllerUsername, // 컨트롤러 예제에서는 주석 처리
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            obscureText: true,
                            autofocus: false,
                            controller: controllerPwd, // 컨트롤러 예제에서는 주석 처리
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            width: 300.0,
                            height: 42.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 222, 234, 187)),
                              ),
                              onPressed: _login,
                              child: const Text(
                                '로그인',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            width: 300.0,
                            height: 42.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 173, 190, 122)),
                              ),
                              onPressed: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    '구글 계정으로 로그인',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage()));
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                ),
                                child: const Text('회원 가입'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('|'),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                ),
                                child: const Text('ID/Password 찾기'),
                              ),
                            ],
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
