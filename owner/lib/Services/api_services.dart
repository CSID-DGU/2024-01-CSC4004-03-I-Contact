import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static Future<bool> duplicate(String id) async {
    var duplicateCheck = false;

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://172.20.10.13:8080/api/v1/owner/duplicate'));
    request.body = jsonEncode({"id": id});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      duplicateCheck = true;
    }
    return duplicateCheck;
  }

  static Future<String> register(
      String username, String name, String email, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://172.20.10.13:8080/api/v1/owner'));
    request.body = jsonEncode({
      "username": username,
      "name": name,
      "email": email,
      "password": password
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    throw Error();
  }

  static void login(String username, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://172.20.10.13:8080/api/v1/owner/login'));
    request.body = json.encode({"username": username, "password": password});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // 로그인 성공
    } else if (response.statusCode == 400) {
      // 로그인 실패
    } else {
      // 로그인 실패
      print(response.reasonPhrase);
    }
    print('logincheck');
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
