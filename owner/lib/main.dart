import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leftover_is_over_owner/Provider/store_state.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_edit.dart';
import 'package:leftover_is_over_owner/Screen/Main/select_store_page.dart';
import 'package:leftover_is_over_owner/Screen/Main/login_page.dart';
import 'package:leftover_is_over_owner/Screen/Main/main_page.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/Order_Manage/order_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/Register/register_complete_page.dart';
import 'package:leftover_is_over_owner/Screen/Register/register_page.dart';
import 'package:leftover_is_over_owner/Screen/Register/store_register_page.dart';
import 'package:leftover_is_over_owner/Screen/Sales_Manage/sales_manage_page.dart';
import 'package:leftover_is_over_owner/Screen/test.dart';
import 'package:leftover_is_over_owner/Screen/Menu_Manage/menu_manage_add.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StoreState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const //SalesManagePage(),
          //SalesManagePage(),
          //OrderStatusPage(StoreState.selling),
          //EditMenu(),
          //AddMenu(),
          //RegisterPage(),
          //SelectStore(),
          //SalesManagePage(),
          LoginPage(),
      //MainPage(),
      //RegisterCompletePage(),
      //MenuManagePage(),

      //StoreRegisterPage('ab', 'av', 'aa', 'aa'),

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
