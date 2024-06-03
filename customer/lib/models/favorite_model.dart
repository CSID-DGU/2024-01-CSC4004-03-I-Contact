import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteModel {
  final int storeId;

  FavoriteModel({
    required this.storeId,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      storeId: json['storeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
    };
  }
}
