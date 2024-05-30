import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_customer/models/food_model.dart';

class FoodService {
  static Future<List<FoodModel>> getFoodListByStoreId(int storeId) async {
    List<FoodModel> foodInstances = [];
    try {
      final response = await http.get(
        Uri.parse('http://loio-server.azurewebsites.net/food/store/$storeId'),
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes); // UTF-8 디코딩
        final List<dynamic> datas = jsonDecode(responseBody);
        for (var data in datas) {
          foodInstances.add(FoodModel.fromJson(data));
        }
        return foodInstances;
      } else {
        throw Exception('Failed to load food list: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
