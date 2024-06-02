import 'dart:math';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:leftover_is_over_customer/screens/home_screens/main_screen.dart';
import 'package:leftover_is_over_customer/screens/setting_screens/notification_setting_screen.dart';
import 'package:leftover_is_over_customer/screens/setting_screens/profile_edit_screen.dart';
import 'package:leftover_is_over_customer/services/auth_services.dart';

void main() async {
  await _initialize();
  runApp(const App2());
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'nfvpbk98y5');

/*
  var registerCheck = await AuthService.register(
    username: 'bb',
    name: 'bb',
    email: 'bb',
    phone: 'bb',
    password: 'abcd1234',
  );

  if (registerCheck) {
    print('회원가입 성공');
  } else {
    print('회원가입 실패');
  }

  var loginCheck =
      await AuthService.login(username: 'bb', password: 'abcd1234');
  if (loginCheck) {
    print('로그인 성공');
  } else {
    print('로그인 실패');
  }
  */
}

class App2 extends StatelessWidget {
  const App2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0XFF523B2A),
          ),
        ),
        cardColor: const Color(0xffDEEABB),
        primaryColor: const Color(0xffFFC658),
        primaryColorDark: const Color(0XFF523B2A),
        primaryColorLight: const Color.fromARGB(255, 255, 246, 225),
        colorScheme: ColorScheme.fromSwatch(
            backgroundColor: const Color.fromARGB(255, 253, 255, 249)),
      ),
      home: const MainScreen(),
      routes: {
        '/edit-profile': (context) => const ProfileEditScreen(),
        '/notification-settings': (context) =>
            const NotificationSettingScreen(),
      },
    );
  }
}
