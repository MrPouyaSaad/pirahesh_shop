import 'product.dart';

class CartItemEntity {
  final ProductEntity product;
  final int id;
  int quantity;
  bool deleteButtonLoading = false;
  bool changeCountLoading = false;

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = ProductEntity.fromJson(json['product']),
        id = json['id'],
        quantity = json['quantity'];

  static List<CartItemEntity> parseJsonArray(List<dynamic> jsonArray) {
    final List<CartItemEntity> cartItems = [];
    jsonArray.forEach((element) {
      cartItems.add(CartItemEntity.fromJson(element));
    });
    return cartItems;
  }
}
