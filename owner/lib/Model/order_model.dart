class OrderModel {
  CustomerModel customer;
  String orderDate;
  String status;
  int orderNum;
  bool appPay;
  List<OrderInfoModel> orderInfo;

  OrderModel({
    required this.customer,
    required this.orderDate,
    required this.status,
    required this.orderNum,
    required this.appPay,
    required this.orderInfo,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var orderInfoFromJson = json['orderInfo'] as List;
    List<OrderInfoModel> orderInfoList = orderInfoFromJson
        .map((orderInfoJson) => OrderInfoModel.fromJson(orderInfoJson))
        .toList();

    return OrderModel(
      customer: CustomerModel.fromJson(json['customer']),
      orderDate: json['orderDate'],
      status: json['status'],
      orderNum: json['orderNum'],
      appPay: json['appPay'],
      orderInfo: orderInfoList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> orderInfoList =
        orderInfo.map((orderInfo) => orderInfo.toJson()).toList();

    return {
      'customer': customer.toJson(),
      'orderDate': orderDate,
      'status': status,
      'orderInfo': orderInfoList,
    };
  }
}

class CustomerModel {
  String username;
  String phoneNum;
  String email;

  CustomerModel(
      {required this.username, required this.phoneNum, required this.email});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      username: json['username'],
      phoneNum: json['phoneNum'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phoneNum': phoneNum,
      'email': email,
    };
  }
}

class OrderInfoModel {
  String name;
  int count;

  OrderInfoModel({required this.name, required this.count});

  factory OrderInfoModel.fromJson(Map<String, dynamic> json) {
    return OrderInfoModel(
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
