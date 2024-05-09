import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Screen/login_page.dart';
import 'package:leftover_is_over_owner/Screen/main_page.dart';
import 'package:leftover_is_over_owner/Screen/register_complete_page.dart';
import 'package:leftover_is_over_owner/Screen/register_page.dart';
import 'package:leftover_is_over_owner/Screen/store_register_page.dart';
import 'package:leftover_is_over_owner/Screen/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      //RegisterCompletePage(),
      //RegisterPage(),
      //StoreRegisterPage('ab', 'av', 'aa', 'aa'),
    );
  }
}
