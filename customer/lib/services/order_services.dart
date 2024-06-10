import 'package:leftover_is_over_customer/models/get_order_model.dart';
import 'package:leftover_is_over_customer/models/order_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_customer/services/auth_services.dart';

class OrderService {
  static Future<bool> placeOrder({
    required int storeId,
    required List<FoodOrder> food,
    required bool appPay,
  }) async {
    try {
      var token = await AuthService.loadToken();
      if (token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${token[0]} ${token[1]}'
      };

      var order = OrderModel(storeId: storeId, food: food, appPay: appPay);
      var request = http.Request(
          'POST', Uri.parse('http://loio-server.azurewebsites.net/order'));
      request.body = jsonEncode(order.toJson());
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        if (responseBody.isEmpty) {
          return false; // 실패
        } else {
          return true; // 성공
        }
      } else {
        throw Exception(
            'Failed to place order: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      print('Error: $e'); // 로그 추가
      rethrow; // 예외 재던지기
    }
  }

  static Future<List<GetOrderModel>> getOrders() async {
    try {
      var token = await AuthService.loadToken();
      if (token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${token[0]} ${token[1]}'
      };

      var request = http.Request('GET',
          Uri.parse('http://loio-server.azurewebsites.net/customer/order'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(responseBody);
        print('Decoded JSON: $jsonData');
        List<GetOrderModel> orders = jsonData
            .map((data) => GetOrderModel.fromJson(data))
            .toList(); // JSON 데이터를 GetOrderModel 객체로 변환
        return orders;
      } else {
        throw Exception(
            'Failed to get orders: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      print('Error: $e'); // 로그 추가
      rethrow; // 예외 재던지기
    }
  }

  static Future<bool> deleteOrder({required int orderId}) async {
    try {
      var token = await AuthService.loadToken();
      if (token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${token[0]} ${token[1]}'
      };

      var body = jsonEncode({'orderId': orderId}); // 'orderNum' 필드 포함

      var response = await http.post(
        Uri.parse('http://loio-server.azurewebsites.net/order/cancel'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return true; // 성공
      } else {
        throw Exception(
            'Failed to delete order: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e'); // 로그 추가
      rethrow; // 예외 재던지기
    }
  }

  static Future<bool> updateOrderStatus(
      {required int orderId, required String status}) async {
    final response = await http.put(
      Uri.parse(
          'http://loio-server.azurewebsites.net/api/orders/$orderId/status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(
          'Failed to update order status: ${response.statusCode} - ${response.reasonPhrase}');
      return false;
    }
  }
}
