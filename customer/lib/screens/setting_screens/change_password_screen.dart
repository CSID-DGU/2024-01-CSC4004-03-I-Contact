import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_customer/services/auth_services.dart'; // Assuming this contains the passwordModify function

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      String currentPassword = _currentPasswordController.text;
      String newPassword = _newPasswordController.text;
      String confirmPassword = _confirmPasswordController.text;

      // Check if new password and confirm password match
      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('새 비밀번호가 일치하지 않습니다.')),
        );
        return;
      }

      // Call the passwordModify function to update password
      bool success = await AuthService.passwordModify(newPassword);

      if (success) {
        // Clear text fields on success
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('비밀번호가 변경되었습니다.')),
        );
      } else {
        // Handle error, show a snackbar or dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('비밀번호 변경에 실패했습니다.'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 변경'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.03),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: '새 비밀번호'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '새 비밀번호를 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: '새 비밀번호 확인'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '새 비밀번호 확인을 입력하세요';
                  }
                  if (value != _newPasswordController.text) {
                    return '새 비밀번호가 일치하지 않습니다';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.05),
              ElevatedButton(
                onPressed: _changePassword,
                child: const Text('비밀번호 변경'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
