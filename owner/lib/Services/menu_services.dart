import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // rootBundle 사용을 위해 추가
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_owner/Model/menu_model.dart';
import 'package:leftover_is_over_owner/Services/auth_services.dart';

class MenuService {
  static Future<bool> addMenu(
      {required String name,
      required int firstPrice,
      required int sellPrice,
      File? file}) async {
    print("addMenu 호출됨");
    try {
      var token = await AuthService.loadToken();
      var headers = {
        'Authorization': '${token[0]} ${token[1]}',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://loio-server.azurewebsites.net/food'),
      );

      request.headers.addAll(headers);
      request.fields['name'] = name;
      request.fields['firstPrice'] = firstPrice.toString();
      request.fields['sellPrice'] = sellPrice.toString();

      if (file != null) {
        print("사용자 지정 파일 추가됨: ${file.path}");
        request.files.add(http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split('/').last,
        ));
      } else {
        // Flutter 애셋 파일 경로 지정
        String defaultImagePath = 'images/default_image.png';

        // Flutter 애셋을 ByteData로 로드
        ByteData byteData = await rootBundle.load(defaultImagePath);
        List<int> imageData = byteData.buffer.asUint8List();

        // MultipartFile로 변환
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          imageData,
          filename: 'default_image.png',
        ));
        print("기본 이미지 파일 추가됨");
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        if (responseBody.isEmpty) {
          return false; // 실패
        } else {
          return true; // 성공
        }
      } else {
        print('Failed to add Menu: ${response.statusCode}');
        throw Exception('Failed to add Menu: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
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

  static Future<List<MenuModel>> getVisibleMenuList() async {
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
            if (instance.visible) {
              print('add');
              menuInstances.add(instance);
            }
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

  static Future<bool> updateMenuCapacity(int foodId, bool add) async {
    try {
      late dynamic url;
      if (add) {
        url =
            Uri.parse('http://loio-server.azurewebsites.net/food/$foodId/add');
      } else {
        url = Uri.parse(
            'http://loio-server.azurewebsites.net/food/$foodId/minus');
      }
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
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

  static Future<bool> setMenu(
      {required int foodId,
      required String capacity,
      required bool visible}) async {
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
          "capacity": int.parse(capacity),
          "isVisible": visible,
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
