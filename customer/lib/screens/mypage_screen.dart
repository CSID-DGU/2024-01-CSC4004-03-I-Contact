import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('마이페이지')),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Profile',
                icon: Icon(Icons.account_circle),
              ),
              Tab(
                text: 'Settings',
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Add notification button functionality
              },
            ),
          ],
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_image.jpg'),
          ),
          const SizedBox(height: 20),
          const Text(
            'User Name',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'user@example.com',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add edit profile functionality
            },
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add settings functionality
            },
            child: const Text('Change Password'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Add logout functionality
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
