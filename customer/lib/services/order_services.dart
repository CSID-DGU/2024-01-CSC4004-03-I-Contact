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

      // 로그 추가
      print('Request URL: ${request.url}');
      print('Request Headers: ${request.headers}');
      print('Request Body: ${request.body}');

      http.StreamedResponse response = await request.send();

      // 로그 추가
      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');

      // 응답 본문 출력
      String responseBody = await response.stream.bytesToString();
      print('Response Body: $responseBody');

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
}
