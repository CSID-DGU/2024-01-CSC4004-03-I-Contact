import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:leftover_is_over_customer/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static List<String> roles = ['customer'];
  static late UserModel user;

  static Future<bool> duplicate(String id) async {
    var duplicateCheck = false;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('http://loio-server.azurewebsites.net/duplicate-username'));
    request.body = jsonEncode({"username": id});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      duplicateCheck = true;
    }
    return duplicateCheck;
  }

  static Future<bool> register({
    required String username,
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://loio-server.azurewebsites.net/member'));
    request.body = jsonEncode({
      "username": username,
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "roles": roles,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> login(
      {required String username, required String password}) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://loio-server.azurewebsites.net/login'));
    request.body = json.encode({
      "username": username,
      "password": password,
      "roles": roles,
    });
    request.headers.addAll(headers);
    var client = http.Client();
    try {
      // 요청을 보내고 타임아웃을 설정
      http.StreamedResponse response = await client
          .send(request)
          .timeout(const Duration(seconds: 120), onTimeout: () {
        // 타임아웃 발생 시
        client.close(); // 클라이언트 닫기
        throw Exception('Request timeout');
      });

      if (response.statusCode == 200) {
        // 로그인 성공
        String responseBody = await response.stream.bytesToString();
        var token = jsonDecode(responseBody);
        await saveToken(token);
        return true;
      } else if (response.statusCode == 400) {
        // 없는 로그인 정보가 입력되었을 경우
        return false;
      } else {
        print(response.statusCode); // 기타 로그인 Service error
        return false;
      }
    } catch (e) {
      //  request Timeout시
      print('Error: $e');
      return false;
    } finally {
      client.close(); // 클라이언트 닫기
    }
  }

  static Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> emptyToken = List.empty();
    await prefs.setStringList('token', emptyToken);
    return true;
  }

  static Future<void> saveToken(Map<String, dynamic> token) async {
    List<String> tokenList = List.filled(3, '');
    token.forEach((key, value) {
      switch (key) {
        case 'grantType':
          tokenList[0] = value;
          break;
        case 'accessToken':
          tokenList[1] = value;
          break;
        case 'refreshToken':
          tokenList[2] = value;
          break;
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('token', tokenList);
  }

  static Future<List<String>> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('token')!;
  }

  static Future<UserModel> getUserModel() async {
    try {
      var token = await AuthService.loadToken();
      if (token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${token[0]} ${token[1]}'
      };

      var response = await http.get(
        Uri.parse('http://loio-server.azurewebsites.net/member'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> data = jsonDecode(responseBody);
        return UserModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to Get Member: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e'); // 로그 추가
      rethrow; // 예외 재던지기
    }
  }

  static Future<bool> memberModify({
    required String name,
    required String email,
  }) async {
    try {
      var token =
          await loadToken(); // Assuming loadToken() loads authentication token
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': '${token[0]} ${token[1]}'
      };
      var request = http.Request(
        'PATCH',
        Uri.parse('http://loio-server.azurewebsites.net/member'),
      );
      request.body = jsonEncode({
        "name": name,
        "email": email,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return true; // Successfully updated
      } else {
        print('Failed to update profile: ${response.statusCode}');
        return false; // Failed to update
      }
    } catch (e) {
      print('Error updating profile: $e');
      return false; // Failed due to an exception
    }
  }
}
