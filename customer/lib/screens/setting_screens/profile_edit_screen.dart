import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_customer/services/auth_services.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 수정'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String name = _nameController.text;
                    String email = _emailController.text;
                    // You may prompt for additional fields like password
                    bool success = await AuthService.memberModify(
                        name: name, email: email // Add password if needed
                        );

                    if (success) {
                      // Navigate back if update successful
                      Navigator.pop(context);
                    } else {
                      // Handle error, show a snackbar or dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('프로필 업데이트에 실패했습니다.'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<String>> loadToken() async {
  // Replace with your token loading logic
  // Example implementation:
  // await Future.delayed(Duration(seconds: 1)); // Simulating async operation
  return ['Bearer', 'your_token_here'];
}
