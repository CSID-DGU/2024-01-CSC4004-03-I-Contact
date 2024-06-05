class OrderModel {
  final Customer customer;
  final String orderDate;
  final String status;
  final int orderNum;
  final bool appPay;
  final List<OrderedFoodInfo> orderedFoodInfo;

  OrderModel({
    required this.customer,
    required this.orderDate,
    required this.status,
    required this.orderNum,
    required this.appPay,
    required this.orderedFoodInfo,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      customer: Customer.fromJson(json['customer']),
      orderDate: json['orderDate'],
      status: json['status'],
      orderNum: json['orderNum'],
      appPay: json['appPay'],
      orderedFoodInfo: List<OrderedFoodInfo>.from(
        json['orderedFoodInfo'].map((item) => OrderedFoodInfo.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(),
      'orderDate': orderDate,
      'status': status,
      'orderNum': orderNum,
      'appPay': appPay,
      'orderedFoodInfo': orderedFoodInfo.map((item) => item.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phone': phone,
      'email': email,
    };
  }
}

class OrderedFoodInfo {
  final String name;
  final int count;

  OrderedFoodInfo({
    required this.name,
    required this.count,
  });

  factory OrderedFoodInfo.fromJson(Map<String, dynamic> json) {
    return OrderedFoodInfo(
      name: json['name'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
    };
  }
}
