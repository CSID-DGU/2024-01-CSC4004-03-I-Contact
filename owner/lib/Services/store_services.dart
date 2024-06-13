import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Model/user_model.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Model/store_model.dart';
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_owner/Services/auth_services.dart';

class StoreService {
  static Future<StoreModel> getStoreInfo() async {
    try {
      var token = await AuthService.loadToken();
      var headers = {'Authorization': '${token[0]} ${token[1]}'};
      var request = http.Request(
          'GET', Uri.parse('http://loio-server.azurewebsites.net/store'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        dynamic storeGet = jsonDecode(responseBody);
        var store = StoreModel.fromJson(storeGet);
        return store;
      } else {
        throw Exception('Failed to load store: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> getStoreState() async {
    try {
      var token = await AuthService.loadToken();
      var headers = {'Authorization': '${token[0]} ${token[1]}'};
      var request = http.Request(
          'GET', Uri.parse('http://loio-server.azurewebsites.net/store'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        dynamic storeGet = jsonDecode(responseBody);
        var store = StoreModel.fromJson(storeGet);
        return store.isOpen;
      } else {
        throw Exception('Failed to load store: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserModel> getUserInfo() async {
    // 서버측 api 미완 get인지 post인지, url 뭔지
    try {
      var token = await AuthService.loadToken();
      var headers = {'Authorization': '${token[0]} ${token[1]}'};
      var request = http.Request(
          'GET', Uri.parse('http://loio-server.azurewebsites.net/member'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        dynamic userGet = jsonDecode(responseBody);
        var user = UserModel.fromJson(userGet);
        return user;
      } else {
        throw Exception('Failed to load ownerInfo: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> changeStoreState() async {
    print("실행중인지");
    try {
      var token = await AuthService.loadToken();
      var headers = {'Authorization': '${token[0]} ${token[1]}'};
      var request = http.Request(
          'POST', Uri.parse('http://loio-server.azurewebsites.net/store/open'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print("바꿈!");
        return true;
      } else {
        throw Exception('Failed to load ownerInfo: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> sendFirebaseToken() async {
    var fireToken = await FirebaseMessaging.instance.getToken();
    try {
      var token = await AuthService.loadToken();
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${token[0]} ${token[1]}'
      };
      var request = http.Request('POST',
          Uri.parse('http://loio-server.azurewebsites.net/save-fcm-token'));
      request.body = jsonEncode({"fcmToken": fireToken});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to load ownerInfo: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
