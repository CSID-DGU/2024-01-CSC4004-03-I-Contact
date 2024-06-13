import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:leftover_is_over_owner/Model/store_model.dart';
import 'package:leftover_is_over_owner/Services/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static List<String> roles = ['owner'];
  static late StoreModel store;

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
    print('회원가입API:${response.statusCode}');
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> storeRegister({
    // 나중에 확인
    required String username,
    required String storeName,
    required String startTime,
    required String endTime,
    required String address,
    required String storePhone,
    required int categoryId,
  }) async {
    try {
      var registerCheck = false;
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('http://loio-server.azurewebsites.net/store'));
      request.body = jsonEncode({
        "username": username,
        "name": storeName,
        "startTime": startTime,
        "endTime": endTime,
        "address": address,
        "phone": storePhone,
        "categoryId": categoryId,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      print('매장생성API:${response.statusCode}');
      if (response.statusCode == 201) {
        registerCheck = true;
        return registerCheck;
      } else {
        throw Exception('Failed to register store.');
      }
    } catch (e) {
      print(e);
      rethrow;
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
          .timeout(const Duration(seconds: 20), onTimeout: () {
        // 타임아웃 발생 시
        client.close(); // 클라이언트 닫기
        throw Exception('Request timeout');
      });
      print("내가왔다");
      print(username);
      print(password);

      if (response.statusCode == 200) {
        // 로그인 성공
        String responseBody = await response.stream.bytesToString();
        var token = jsonDecode(responseBody);
        await saveToken(token);
        return true;
      } else if (response.statusCode == 400) {
        print("실패 ㅠㅠ");
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

  static Future<String> findUserName(
      {required String name,
      required String email,
      required String phone}) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('http://loio-server.azurewebsites.net/find-username'));
    request.body = json.encode({
      "name": name,
      "email": email,
      "phone": phone,
    });
    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(responseBody);
        if (decodedResponse != null &&
            decodedResponse.containsKey('username')) {
          return decodedResponse['username'];
        } else {
          print('Username not found in response');
          return '';
        }
      } else if (response.statusCode == 400) {
        print("400에러 $responseBody");
        return '';
      } else {
        print(response.statusCode); // 기타 로그인 Service error
        return '';
      }
    } catch (e) {
      //  request Timeout시
      print('Error: $e');
      return '';
    }
  }

  static Future<bool> resetPassword(
      {required String username,
      required String name,
      required String email,
      required String phone,
      required String newPassword}) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('http://loio-server.azurewebsites.net/reset-password'));
    request.body = json.encode({
      "username": username,
      "name": name,
      "email": email,
      "phone": phone,
      "newPassword": newPassword,
    });
    request.headers.addAll(headers);
    print('das');
    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return true;
      } else {
        print("${response.statusCode}에러 $responseBody");
        return false;
      }
    } catch (e) {
      //  request Timeout시
      print('Error: $e');
      rethrow;
    }
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

  static Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> emptyToken = List.empty();
    await prefs.setStringList('token', emptyToken);
    return true;
  }

  static Future<bool> memberModify({
    // 나중에 수정하기
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    var token = await loadToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${token[0]} ${token[1]}'
    };
    var request = http.Request(
        'PATCH', Uri.parse('http://loio-server.azurewebsites.net/member'));
    request.body = jsonEncode({
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }

  static Future<bool> storeModify({
    // 일단 memberModify랑 같게 만들어둠 나중에 수정하기
    required String name,
    required String startTime,
    required String endTime,
    required String adress,
    required String phone,
    required int categoryID, //Long 타입 안된다고해서 일단 int
  }) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('PATCH',
        Uri.parse('http://loio-server.azurewebsites.net/store/{storeId}'));
    request.body = jsonEncode({
      "name": String,
      "startTime": String,
      "endTime": String,
      "address": String,
      "phone": String,
      "categoryId": int
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
