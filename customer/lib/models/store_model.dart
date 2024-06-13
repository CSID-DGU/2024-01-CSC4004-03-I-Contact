import 'dart:ffi';

class StoreModel {
  final int storeId;
  final String name;
  final String startTime;
  final String endTime;
  final String address;
  final String phone;
  final int categoryId;
  final bool open;

  StoreModel({
    required this.storeId,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.address,
    required this.phone,
    required this.categoryId,
    required this.open,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeId: json['storeId'],
      name: json['name'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      address: json['address'],
      phone: json['phone'],
      categoryId: json['categoryId'],
      open: json['open'],
    );
  }
}
