import 'package:leftover_is_over_customer/models/favorite_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leftover_is_over_customer/services/auth_services.dart';

class FavoriteService {
  static Future<bool> makeFavorite({
    required int storeId,
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

      var favorite = FavoriteModel(storeId: storeId);
      var request = http.Request(
          'POST', Uri.parse('http://loio-server.azurewebsites.net/favorite'));
      request.body = jsonEncode(favorite.toJson());
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return true; // 성공
      } else {
        throw Exception(
            'Failed to place favorite: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      print('Error: $e'); // 로그 추가
      rethrow; // 예외 재던지기
    }
  }

  static Future<List<FavoriteModel>> getFavorites() async {
    try {
      var token = await AuthService.loadToken();
      if (token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${token[0]} ${token[1]}'
      };

      var response = await http.get(
        Uri.parse('http://loio-server.azurewebsites.net/favorite'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> favoritesJson = jsonDecode(response.body);
        List<FavoriteModel> favorites =
            favoritesJson.map((json) => FavoriteModel.fromJson(json)).toList();
        return favorites;
      } else {
        throw Exception(
            'Failed to fetch favorites: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e'); // 로그 추가
      rethrow; // 예외 재던지기
    }
  }

  static Future<bool> deleteFavorite({
    required int storeId,
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

      var body = jsonEncode({'storeId': storeId});

      var response = await http.delete(
        Uri.parse('http://loio-server.azurewebsites.net/favorite'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return true; // 성공
      } else {
        throw Exception(
            'Failed to delete favorite: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e'); // 로그 추가
      rethrow; // 예외 재던지기
    }
  }
}
