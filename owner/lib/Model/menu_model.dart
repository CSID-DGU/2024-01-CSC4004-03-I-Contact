class MenuModel {
  final int foodId;
  final int storeId;
  final String name;
  final int firstPrice;
  final int sellPrice;
  final int capacity;
  final int visits;
  final bool isVisible;
  final bool deleted;

  // 일반 생성자
  MenuModel({
    required this.foodId,
    required this.storeId,
    required this.name,
    required this.firstPrice,
    required this.sellPrice,
    required this.capacity,
    required this.visits,
    required this.isVisible,
    required this.deleted,
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
        isVisible = json['isVisible'],
        deleted = json['deleted'];
}
