import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController controllerId, controllerPwd;
  @override
  void initState() {
    // TODO: implement initState
    controllerId = TextEditingController();
    controllerPwd = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.amber[600],
          appBar: AppBar(
            title: const Center(
              child: Text(
                '로그인 페이지',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Column의 높이를 최소로 설정
                children: [
                  const SizedBox(height: 30),
                  const CircleAvatar(
                    // Flexible 제거
                    backgroundColor: Colors.white,
                    radius: 100.0, // 원래는 1000.0이었으나 실제 사용 가능한 크기로 조정
                  ),
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'ID',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        controller: controllerId, // 컨트롤러 예제에서는 주석 처리
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
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: true,
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
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green[400]),
                          ),
                          onPressed: () {
                            print('Input id: ${controllerId.text}');
                            print('Input id: ${controllerPwd.text}');
                          },
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
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green[600]),
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
                            onPressed: () {},
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
          )),
    );
  }
}
