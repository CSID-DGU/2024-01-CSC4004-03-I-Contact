class OrderModel {
  final String customerId;
  final String storeId;
  final String orderDate;
  final Map<String, int> orderInfo;
  final String status;

  OrderModel.fromJson(Map<String, dynamic> json)
      : customerId = json['customerId'], // json 안에 json으로 바뀌기!! 객체
        storeId = json['storeId'],
        orderDate = json['orderDate'],
        orderInfo = json['orderInfo'],
        status = json['status'];
}
