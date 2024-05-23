import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:leftover_is_over_owner/Model/store_model.dart';
import 'package:leftover_is_over_owner/Services/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static List<String> roles = ['owner'];
  static late StoreModel store;

  static Future<bool> duplicate(String id) async {
    var duplicateCheck = false;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('http://loio-server.azurewebsites.net/duplicate-username'));
    request.body = jsonEncode({"username": id});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      duplicateCheck = true;
    }
    return duplicateCheck;
  }

  static Future<bool> register({
    required String username,
    required String name,
    required String email,
    required String password,
  }) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://loio-server.azurewebsites.net/member'));
    request.body = jsonEncode({
      "username": username,
      "name": name,
      "email": email,
      "password": password,
      "roles": roles,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> storeRegister({
    // 나중에 확인
    required String userName,
    required String storeName,
    required String startTime,
    required String endTime,
    required String address,
    required String storePhone,
    required int categoryId,
  }) async {
    var duplicateCheck = false;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://loio-server.azurewebsites.net/store'));
    request.body = jsonEncode({
      "username": userName,
      "name": storeName,
      "startTime": startTime,
      "endTime": endTime,
      "address": address,
      "phone": storePhone,
      "categoryId": categoryId,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      duplicateCheck = true;
      print(response.statusCode);
    }
    print(response.statusCode);
    return duplicateCheck;
  }

  static Future<bool> login(
      {required String username, required String password}) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://loio-server.azurewebsites.net/login'));
    request.body = json.encode({
      "username": username,
      "password": password,
      "roles": roles,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var token = jsonDecode(responseBody);
      //print(result);
      await saveToken(token);
      return true;
      // 로그인 성공
    } else if (response.statusCode == 400) {
      print('login실패');
      return false;
      // 로그인 실패
    } else {
      print(response.statusCode);
      return false;
      // 로그인 실패
    }
  }

  static Future<void> saveToken(Map<String, dynamic> token) async {
    List<String> tokenList = List.filled(3, '');
    token.forEach((key, value) {
      switch (key) {
        case 'grantType':
          tokenList[0] = value;
          break;
        case 'accessToken':
          tokenList[1] = value;
          break;
        case 'refreshToken':
          tokenList[2] = value;
          break;
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('token', tokenList);
  }

  static Future<List<String>> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('token')!;
  }

  static Future<StoreModel> getStore() async {
    try {
      var token = await loadToken();
      var headers = {'Authorization': '${token[0]} ${token[1]}'};
      var request = http.Request(
          'GET', Uri.parse('http://loio-server.azurewebsites.net/store'));
      request.headers.addAll(headers);
      print('여기');
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print('여기2');
        String responseBody = await response.stream.bytesToString();
        print('여기3');
        dynamic storeGet = jsonDecode(responseBody);
        print('storeGet: $storeGet');
        store = StoreModel.fromJson(storeGet);
        print(store);
        return store;
      } else {
        throw Exception('Failed to load store: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching store: $e');
    }
  }

/*
  static List<WebtoonModel> webtoonInstances = [];

  static Future<List<WebtoonModel>> getTodaysToons() async {
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        final instance = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(instance);
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonbyId(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodeById(
      String id) async {
    List<WebtoonEpisodeModel> episodeInstances = [];

    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        var ins = WebtoonEpisodeModel.fromJson(episode);
        episodeInstances.add(ins);
      }
      return episodeInstances;
    }
    throw Error();
  }
  */
}
