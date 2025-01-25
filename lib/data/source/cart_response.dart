import '../model/cart_item.dart';

class CartResponse {
  final List<CartItemEntity> cartItems;
  final int payablePrice;
  final int totalPrice;
  final int shipingCost;

  CartResponse.fromJson(Map<String, dynamic> json)
      : cartItems = CartItemEntity.parseJsonArray(
          json["cart_item"],
        ),
        payablePrice = json["payable_price"],
        totalPrice = json["total_price"],
        shipingCost = json["shiping_cost"];
}
