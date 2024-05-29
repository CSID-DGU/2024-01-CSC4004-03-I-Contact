import 'dart:convert';
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Model/user_model.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Model/store_model.dart';
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_owner/Services/auth_services.dart';

class MenuService {
  static Future<bool> addMenu({
    required String name,
    required int firstPrice,
    required int sellPrice,
  }) async {
    try {
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
      print(e);
      rethrow;
    }
  }

  static Future<bool> deleteMenu(int foodId) async {
    try {
      var request = http.Request('DELETE',
          Uri.parse('http://loio-server.azurewebsites.net/food/$foodId'));

      http.StreamedResponse streamedResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete Menu: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<List<MenuModel>> getMenuList() async {
    List<MenuModel> menuInstances = [];
    try {
      var token = await AuthService.loadToken();
      var headers = {'Authorization': '${token[0]} ${token[1]}'};
      var request = http.Request(
          'GET', Uri.parse('http://loio-server.azurewebsites.net/food'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        List<dynamic> menuList = jsonDecode(responseBody);
        if (menuList.isNotEmpty) {
          for (var menu in menuList) {
            var instance = MenuModel.fromJson(menu);
            menuInstances.add(instance);
          }
        }
        return menuInstances;
      } else {
        throw Exception('Failed to load menuList: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<bool> updateMenuInfo(MenuModel menu) async {
    try {
      final url =
          Uri.parse('http://loio-server.azurewebsites.net/food/${menu.foodId}');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": menu.name,
          "firstPrice": menu.firstPrice,
          "sellPrice": menu.sellPrice,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // 오류 처리
        throw Exception('Failed to update menu.');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<bool> setInitialCapacity(
      {required int foodId, required String capacity}) async {
    try {
      final url =
          Uri.parse('http://loio-server.azurewebsites.net/food/$foodId');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "foodId": foodId,
          "capacity": capacity,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update initial capacity.');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
