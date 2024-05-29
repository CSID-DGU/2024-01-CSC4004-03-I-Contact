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
        final List<dynamic> datas = jsonDecode(response.body);
        for (var data in datas) {
          foodInstances.add(FoodModel.fromJson(data));
        }
        return foodInstances;
      } else {
        throw Exception('Failed to load store: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
