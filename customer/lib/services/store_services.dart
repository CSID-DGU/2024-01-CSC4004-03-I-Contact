import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_customer/models/store_model.dart';

class StoreService {
  static Future<StoreModel> getStoreById(int storeId) async {
    try {
      final response = await http.get(
        Uri.parse('http://loio-server.azurewebsites.net/store/$storeId'),
      );

      /*
      - POST할 때
      final response = await http.post(
      Uri.parse('http://loio-server.azurewebsites.net/store/$storeId'),
        body: {
          'key1': 'value1',
          'key2': 'value2',
        },
      );
      */

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return StoreModel.fromJson(data);
      } else {
        throw Exception('Failed to load store: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // 다른 메서드들...
}
