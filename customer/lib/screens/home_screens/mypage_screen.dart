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
              child:
                  Text('마이페이지', style: TextStyle(fontWeight: FontWeight.w600))),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: '프로필',
                icon: Icon(Icons.account_circle),
              ),
              Tab(
                text: '설정',
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Profile section
            ProfileSection(),
            // Settings section
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
            backgroundImage: AssetImage('assets/profile_image.jpg'),
          ),
          SizedBox(height: screenHeight * 0.03),
          const Text(
            '유저 이름',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: screenHeight * 0.01),
          const Text(
            '아이디123',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: screenHeight * 0.03),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileEditScreen()),
              );
            },
            child: const Text('프로필 수정'),
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
    //_isDropdownVisible = false;
    var logout = await AuthService
        .logout(); // async 가 되어있어야하는지 유의 future<bool>이 넘어오기 때문에
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: screenHeight * 0.05),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationSettingScreen()),
              );
            },
            child: const Text('알림 설정'),
          ),
          SizedBox(height: screenHeight * 0.01),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen()),
              );
            },
            child: const Text('비밀번호 변경'),
          ),
          SizedBox(height: screenHeight * 0.01),
          ElevatedButton(
            onPressed: _logout,
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
