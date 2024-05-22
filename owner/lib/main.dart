import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leftover_is_over_owner/Screen/menu_manage_edit.dart';
import 'package:leftover_is_over_owner/Screen/select_store_page.dart';
import 'package:leftover_is_over_owner/Screen/login_page.dart';
import 'package:leftover_is_over_owner/Screen/main_page.dart';
import 'package:leftover_is_over_owner/Screen/menu_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/sales_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/register_complete_page.dart';
import 'package:leftover_is_over_owner/Screen/register_page.dart';
import 'package:leftover_is_over_owner/Screen/store_register_page.dart';
import 'package:leftover_is_over_owner/Screen/test.dart';
import 'package:leftover_is_over_owner/Screen/menu_manage_add.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: // MainPage(),
          //EditMenu(),
          //AddMenu(),
          //RegisterPage(),
          //SelectStore(),
          //SalesManagePage()
          //MainPage()
          const LoginPage(),
      //RegisterCompletePage(),

      //const StoreRegisterPage('ab', 'av', 'aa', 'aa'),

      // 모든 페이지 상단바 색상 지정
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 255, 198, 88),
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      builder: (context, child) {
        return child!;
      },
    );
  }
}
