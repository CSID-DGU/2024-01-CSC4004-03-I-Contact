import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static String ipAddress = '';

  static Future<bool> duplicate(String id) async {
    print('duplicate');
    var duplicateCheck = false;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('http://$ipAddress:8080/api/v1/owner/check-duplicate-id'));
    request.body = jsonEncode({"id": id});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      duplicateCheck = true;
    }
    print(response.statusCode);
    return duplicateCheck;
  }

  static Future<bool> register(
      String username, String name, String email, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://$ipAddress:8080/api/v1/owner'));
    request.body = jsonEncode({
      "username": username,
      "name": name,
      "email": email,
      "password": password
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return true;
      print('회원가입 성공');
      print(await response.stream.bytesToString());
    } else {
      return false;
      print('회원가입 실패');
    }
  }

  static Future<bool> storeRegister({
    required String storeName,
    required String startTime,
    required String endTime,
    required String address,
    required String storePhone,
    required String businessNum,
  }) async {
    print('API: storeRegister');
    var duplicateCheck = false;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://$ipAddress:8080/api/v1/owner/register/store-register'));
    request.body = jsonEncode({
      "name": storeName,
      "startTime": startTime,
      "endTime": endTime,
      "address": address,
      "phone": storePhone,
      "businessNum": businessNum,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      duplicateCheck = true;
    }
    print(response.statusCode);
    return duplicateCheck;
  }

  static void login(String username, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://$ipAddress:8080/api/v1/owner/login'));
    request.body = json.encode({"username": username, "password": password});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // 로그인 성공
    } else if (response.statusCode == 400) {
      print('login실패');

      // 로그인 실패
    } else {
      // 로그인 실패
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
