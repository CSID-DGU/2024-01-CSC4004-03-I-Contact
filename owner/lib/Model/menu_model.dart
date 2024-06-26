class MenuModel {
  final int foodId;
  final int storeId;
  String name;
  int firstPrice;
  int sellPrice;
  int capacity;
  final int visits;
  final bool visible; // 무시
  final bool deleted; // 무시
  String imageUrl; // 이미지 URL 필드 추가

  // 일반 생성자
  MenuModel({
    required this.foodId,
    required this.storeId,
    required this.name,
    required this.firstPrice,
    required this.sellPrice,
    required this.capacity,
    required this.visits,
    required this.visible,
    required this.deleted,
    required this.imageUrl,
  });

  // fromJson 생성자
  MenuModel.fromJson(Map<String, dynamic> json)
      : foodId = json['foodId'],
        storeId = json['storeId'],
        name = json['name'],
        firstPrice = json['firstPrice'],
        sellPrice = json['sellPrice'],
        capacity = json['capacity'],
        visits = json['visits'],
        deleted = json['deleted'],
        visible = json['visible'],
        imageUrl = json['imageUrl'];
}
