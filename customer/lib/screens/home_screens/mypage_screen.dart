import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/screens/login_screens/login_screen.dart';
import 'package:leftover_is_over_customer/screens/setting_screens/change_password_screen.dart';
import 'package:leftover_is_over_customer/screens/setting_screens/profile_edit_screen.dart';
import 'package:leftover_is_over_customer/screens/setting_screens/notification_setting_screen.dart';
import 'package:leftover_is_over_customer/Services/auth_services.dart';
import 'package:leftover_is_over_customer/widgets/show_custom_dialog_widget.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text('마이페이지',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 0, 0, 0)))),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: '프로필',
                icon: Icon(Icons.account_circle, color: Colors.amber),
              ),
              Tab(
                text: '설정',
                icon: Icon(Icons.settings, color: Colors.amber),
              ),
            ],
            labelColor: Color.fromARGB(255, 0, 0, 0),
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: const TabBarView(
          children: [
            ProfileSection(),
            SettingsSection(),
          ],
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/no_image.png'),
          ),
          SizedBox(height: screenHeight * 0.03),
          const Text(
            '유저 이름',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          SizedBox(height: screenHeight * 0.01),
          const Text(
            '아이디123',
            style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          SizedBox(height: screenHeight * 0.03),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileEditScreen()),
              );
            },
            child: const Text('프로필 수정', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  void _logout() async {
    var logout = await AuthService.logout();
    if (logout) {
      if (!mounted) {
        return;
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      if (!mounted) {
        return;
      }
      showErrorDialog(context, '로그아웃에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '설정',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          SizedBox(height: screenHeight * 0.05),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationSettingScreen()),
              );
            },
            child: const Text('알림 설정', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: screenHeight * 0.01),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen()),
              );
            },
            child: const Text('비밀번호 변경', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: screenHeight * 0.01),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            onPressed: _logout,
            child: const Text('로그아웃', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
