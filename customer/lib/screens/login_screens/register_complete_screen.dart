import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_customer/screens/login_screens/login_screen.dart';

class RegisterCompletePage extends StatelessWidget {
  const RegisterCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 234, 212),
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
                size: 100,
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          const Text(
            '회원가입이 완료되었습니다!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 250,
          ),
          SizedBox(
            width: 300.0,
            height: 60.0,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 255, 225, 116)),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                '로그인 화면으로 이동',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w900,
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
