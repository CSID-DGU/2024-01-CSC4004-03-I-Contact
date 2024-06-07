import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Screen/Main/login_page.dart';

class GoogleLogin extends StatelessWidget {
  const GoogleLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google 로그인"),
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          //AsyncSnapshot<User>
          if (!snapshot.hasData) {
            return const LoginPage();
          } else {
            return const Center(
              child: Column(
                children: [
                  Text('로그인'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
