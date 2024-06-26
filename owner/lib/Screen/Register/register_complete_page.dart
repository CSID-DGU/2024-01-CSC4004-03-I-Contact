import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Screen/Main/login_page.dart';

class RegisterCompletePage extends StatelessWidget {
  const RegisterCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 198, 88),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 200,
          ),
          Center(
            child: Transform.scale(
              scale: 2.0,
              child: const Icon(
                Icons.check_circle_outline,
                size: 90,
              ),
            ),
          ),
          const SizedBox(
            height: 120,
          ),
          const Text(
            '회원가입이 완료되었습니다!',
            style: TextStyle(
              fontSize: 27,
              fontFamily: "Free2",
            ),
          ),
          const SizedBox(
            height: 200,
          ),
          SizedBox(
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
                  MaterialPageRoute(builder: (context) => const LoginPage()),
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
        ],
      ),
    );
  }
}
