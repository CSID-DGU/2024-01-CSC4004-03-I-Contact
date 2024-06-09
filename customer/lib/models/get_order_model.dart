class GetOrderModel {
  final Customer customer;
  final Store store; // Added store field
  final String orderDate;
  final String status;
  final int orderNum;
  final bool appPay;
  final List<OrderedFood> orderedFood;

  GetOrderModel({
    required this.customer,
    required this.store, // Updated constructor
    required this.orderDate,
    required this.status,
    required this.orderNum,
    required this.appPay,
    required this.orderedFood,
  });

  factory GetOrderModel.fromJson(Map<String, dynamic> json) {
    List<OrderedFood> foodList = [];
    for (var food in json['orderedFood']) {
      foodList.add(OrderedFood.fromJson(food));
    }
    return GetOrderModel(
      customer: Customer.fromJson(json['customer']),
      store: Store.fromJson(json['store']), // Parse store data
      orderDate: json['orderDate'],
      status: json['status'],
      orderNum: json['orderNum'],
      appPay: json['appPay'],
      orderedFood: foodList,
    );
  }
}

class Customer {
  final String username;
  final String phone;
  final String email;

  Customer({
    required this.username,
    required this.phone,
    required this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      username: json['username'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}

class OrderedFood {
  final String name;
  final int count;
  final String imgUrl;

  OrderedFood({
    required this.name,
    required this.count,
    required this.imgUrl,
  });

  factory OrderedFood.fromJson(Map<String, dynamic> json) {
    return OrderedFood(
      name: json['name'],
      count: json['count'],
      imgUrl: json['imgUrl'],
    );
  }
}

class Store {
  final int storeId;
  final String name;

  Store({
    required this.storeId,
    required this.name,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeId: json['storeId'],
      name: json['name'],
    );
  }
}
