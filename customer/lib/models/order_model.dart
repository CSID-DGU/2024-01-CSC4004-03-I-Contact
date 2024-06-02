class OrderModel {
  final int storeId;
  final List<FoodOrder> food;
  final bool appPay;

  OrderModel({
    required this.storeId,
    required this.food,
    required this.appPay,
  });

  // JSON serialization
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      storeId: json['storeId'],
      food: (json['food'] as List<dynamic>)
          .map((item) => FoodOrder.fromJson(item))
          .toList(),
      appPay: json['appPay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'food': food.map((item) => item.toJson()).toList(),
      'appPay': appPay,
    };
  }
}

class FoodOrder {
  final int foodId;
  final int count;

  FoodOrder({
    required this.foodId,
    required this.count,
  });

  // JSON serialization
  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      foodId: json['foodId'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'count': count,
    };
  }
}
