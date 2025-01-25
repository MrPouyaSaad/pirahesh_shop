import 'dart:ffi';

import 'package:pirahesh_shop/data/model/product.dart';

class Order {
  final int id;
  final List<OrderItem> orderItems;
  final String orderNumber;
  final String orderDate;
  final String orderStatus;
  final int count;
  final double totalAmount;

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        orderItems = OrderItem.parseJsonArray(json['items']),
        orderNumber = json['orderNumber'],
        orderDate = json['orderDate'],
        orderStatus = json['status'],
        count = json['totalQuantity'],
        totalAmount = json['totalAmount'];
}

class OrderItem {
  final int id;
  final ProductEntity product;
  final int count;

  OrderItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        count = json['quantity'],
        product = ProductEntity.fromJson(json['product']);

  static List<OrderItem> parseJsonArray(List<dynamic> jsonArray) {
    final List<OrderItem> orderItem = [];
    jsonArray.forEach((element) {
      orderItem.add(OrderItem.fromJson(element));
    });
    return orderItem;
  }
}
