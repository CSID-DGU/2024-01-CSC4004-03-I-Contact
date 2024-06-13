class FoodModel {
  final int foodId;
  final int storeId;
  final String name;
  final int firstPrice;
  final int sellPrice;
  final int capacity;
  final int visits;
  final bool visible;
  final bool deleted;
  final String imageUrl;

  FoodModel({
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

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      foodId: json['foodId'],
      storeId: json['storeId'],
      name: json['name'],
      firstPrice: json['firstPrice'],
      sellPrice: json['sellPrice'],
      capacity: json['capacity'],
      visits: json['visits'],
      visible: json['visible'] ?? false, // Use null-aware operator
      deleted: json['deleted'] ?? false, // Use null-aware operator
      imageUrl: json['imageUrl'], // Set imageUrl from json data
    );
  }
}
