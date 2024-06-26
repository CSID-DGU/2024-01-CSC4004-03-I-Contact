import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_owner/Services/auth_services.dart';

class OrderService {
  static Future<List<OrderModel>> getOrderList(bool getAll) async {
    List<OrderModel> orderInstances = [];
    String url;
    if (getAll) {
      url = 'http://loio-server.azurewebsites.net/owner/order/ALL';
    } else {
      url = 'http://loio-server.azurewebsites.net/owner/order/VISIT';
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
        //print(response.body);
        throw Exception('Failed to load orderList: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> orderCheck(int orderId, bool complete) async {
    try {
      var check = false;
      var headers = {'Content-Type': 'application/json'};
      http.Request request;
      if (complete) {
        request = http.Request('POST',
            Uri.parse('http://loio-server.azurewebsites.net/order/complete'));
      } else {
        request = http.Request('POST',
            Uri.parse('http://loio-server.azurewebsites.net/order/cancel'));
      }
      request.body = jsonEncode({"orderId": orderId});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        check = true;
      } else {
        String responseBody = await response.stream.bytesToString();
        print(responseBody);
        throw Exception('Failed to change orderState: ${response.statusCode}');
      }
      return check;
    } catch (e) {
      rethrow;
    }
  }
}
