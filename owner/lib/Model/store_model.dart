class StoreModel {
  final int storeId;
  final int ownerId;
  final int categoryId;
  final String name;
  final String startTime;
  final String endTime;
  final String address;
  final String phone;
  final bool isOpen;
  final bool deleted;

  StoreModel.fromJson(Map<String, dynamic> json)
      : storeId = json['storeId'],
        ownerId = json['ownerId'],
        categoryId = json['categoryId'],
        name = json['name'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        address = json['address'],
        phone = json['phone'],
        isOpen = json['open'],
        deleted = json['deleted'];
}
