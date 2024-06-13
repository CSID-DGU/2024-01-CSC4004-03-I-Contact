import 'dart:math';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:leftover_is_over_customer/screens/home_screens/main_screen.dart';
import 'package:leftover_is_over_customer/screens/setting_screens/notification_setting_screen.dart';
import 'package:leftover_is_over_customer/screens/setting_screens/profile_edit_screen.dart';
import 'package:leftover_is_over_customer/services/auth_services.dart';
import 'package:leftover_is_over_customer/screens/login_screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  // 백그라운드 메시지 처리를 여기에 추가할 수 있습니다.
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {
  // 백그라운드 알림 처리 로직
}

void initializeNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      // 알림 클릭 시 액션 처리
    },
    onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initializeNotification();

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
 */
  /*var loginCheck =
      await AuthService.login(username: 'customer1', password: 'passwd');
  if (loginCheck) {
    print('로그인 성공');
  } else {
    print('로그인 실패');
  }*/
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
      home: const LoginScreen(),
      // MainScreen(),
      routes: {
        '/edit-profile': (context) => const ProfileEditScreen(),
        '/notification-settings': (context) =>
            const NotificationSettingScreen(),
      },
    );
  }
}
