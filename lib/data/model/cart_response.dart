import 'cart_item.dart';

class CartResponse {
  final List<CartItemEntity> cartItems;
  double payablePrice = 0;
  double totalPrice = 0;
  double shippingCost = 0;

  factory CartResponse.fromJson(List<dynamic> jsonList) {
    final items =
        jsonList.map((item) => CartItemEntity.fromJson(item)).toList();
    return CartResponse(cartItems: items);
  }

  CartResponse({required this.cartItems});
}
