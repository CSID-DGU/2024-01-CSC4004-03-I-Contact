import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_customer/models/store_model.dart';

class StoreService {
  static Future<StoreModel> getStoreById(int storeId) async {
    try {
      final response = await http.get(
        Uri.parse('http://loio-server.azurewebsites.net/store/$storeId'),
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes); // UTF-8 디코딩
        Map<String, dynamic> data = jsonDecode(responseBody);
        return StoreModel.fromJson(data);
      } else {
        throw Exception('Failed to load store: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

class CategorySearchService {
  static Future<List<StoreModel>> getStoreListByCategoryId(
      int categoryId, double latitude, double longitude) async {
    List<StoreModel> storeInstances = [];
    try {
      final response = await http.get(
        Uri.parse(
            'http://loio-server.azurewebsites.net/store/category/$categoryId?latitude=$latitude&longitude=$longitude'),
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes); // UTF-8 디코딩
        final List<dynamic> datas = jsonDecode(responseBody);
        for (var data in datas) {
          storeInstances.add(StoreModel.fromJson(data));
          print(data);
        }
        print(storeInstances);
        return storeInstances;
      } else {
        throw Exception('Failed to load stores: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

class LocationSearchService {
  static Future<List<StoreModel>> getStoreListByLocation(
      double latitude, double longitude) async {
    List<StoreModel> storeInstances = [];
    try {
      final response = await http.get(
        Uri.parse(
            'http://loio-server.azurewebsites.net/store/location?latitude=$latitude&longitude=$longitude'),
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes); // UTF-8 디코딩
        final List<dynamic> datas = jsonDecode(responseBody);
        for (var data in datas) {
          storeInstances.add(StoreModel.fromJson(data));
          print(data);
        }
        print(storeInstances);
        return storeInstances;
      } else {
        throw Exception('Failed to load stores: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

class GetStoreByKeywordService {
  static Future<List<StoreModel>> getStoreListByKeyword(String keyword) async {
    List<StoreModel> storeInstances = [];
    try {
      final response = await http.get(
        Uri.parse(
            'http://loio-server.azurewebsites.net/store/keyword/$keyword'),
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes); // UTF-8 디코딩
        final List<dynamic> datas = jsonDecode(responseBody);
        for (var data in datas) {
          storeInstances.add(StoreModel.fromJson(data));
          print(data);
        }
        print(storeInstances);
        return storeInstances;
      } else {
        throw Exception('Failed to load stores: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
