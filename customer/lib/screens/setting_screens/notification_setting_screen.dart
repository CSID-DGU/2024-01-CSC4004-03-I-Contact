import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  _NotificationSettingScreenState createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool _isFavoriteStoreAdded = true;
  bool _isFavoriteStoreClosed = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavoriteStoreAdded = prefs.getBool('isFavoriteStoreAdded') ?? false;
      _isFavoriteStoreClosed = prefs.getBool('isFavoriteStoreClosed') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFavoriteStoreAdded', _isFavoriteStoreAdded);
    prefs.setBool('isFavoriteStoreClosed', _isFavoriteStoreClosed);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 설정'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('즐겨찾는 가게 음식 등록 시'),
              value: _isFavoriteStoreAdded,
              onChanged: (bool value) {
                setState(() {
                  _isFavoriteStoreAdded = value;
                });
                _saveSettings();
              },
              activeColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: screenHeight * 0.02),
            SwitchListTile(
              title: const Text('즐겨찾는 가게 음식 마감 시'),
              value: _isFavoriteStoreClosed,
              onChanged: (bool value) {
                setState(() {
                  _isFavoriteStoreClosed = value;
                });
                _saveSettings();
              },
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
