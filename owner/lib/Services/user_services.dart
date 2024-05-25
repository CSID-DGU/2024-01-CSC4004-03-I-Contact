import 'dart:convert';
import 'package:leftover_is_over_owner/Model/user_model.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Model/store_model.dart';
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_owner/Services/auth_services.dart';

class UserService {
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
      throw Exception('Error fetching store: $e');
    }
  }

  static Future<UserModel> getUserInfo() async {
    // 서버측 api 미완 get인지 post인지, url 뭔지
    try {
      var token = await AuthService.loadToken();
      var headers = {'Authorization': '${token[0]} ${token[1]}'};
      var request = http.Request(
          'GET', Uri.parse('http://loio-server.azurewebsites.net/store'));
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
      throw Exception('Error fetching ownerInfo: $e');
    }
  }

  static Future<List<OrderModel>> getOrderList(bool getAll) async {
    List<OrderModel> orderInstances = [];
    String url;
    if (getAll) {
      url = 'http://loio-server.azurewebsites.net/owner/order/all';
    } else {
      url = 'http://loio-server.azurewebsites.net/owner/order/visit';
    }
    try {
      var token = await AuthService.loadToken();
      var headers = {'Authorization': '${token[0]} ${token[1]}'};
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        List<dynamic> orderList = jsonDecode(responseBody);
        for (var order in orderList) {
          var instance = OrderModel.fromJson(order);
          orderInstances.add(instance);
        }
        return orderInstances;
      } else {
        throw Exception('Failed to load orderList: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching orderList: $e');
    }
  }

  static Future<bool> changeStoreState() async {
    try {
      var token = await AuthService.loadToken();
      var headers = {'Authorization': '${token[0]} ${token[1]}'};
      var request = http.Request(
          'POST', Uri.parse('http://loio-server.azurewebsites.net/store/open'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to load ownerInfo: ${response.statusCode}');
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addMenu({
    required String name,
    required int firstPrice,
    required int sellPrice,
  }) async {
    try {
      print('1');
      var token = await AuthService.loadToken();
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${token[0]} ${token[1]}'
      };
      var request = http.Request(
          'POST', Uri.parse('http://loio-server.azurewebsites.net/food'));
      request.body = jsonEncode({
        "name": name,
        "firstPrice": firstPrice,
        "sellPrice": sellPrice,
      });
      request.headers.addAll(headers);
      print('2');

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        if (responseBody.isEmpty) {
          return false; // 실패
        } else {
          return true; // 성공
        }
      } else {
        throw Exception('Failed to add Menu: ${response.statusCode}');
      }
    } catch (e) {
      return false;
    }
  }
}
