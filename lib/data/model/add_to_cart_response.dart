import 'package:pirahesh_shop/data/model/product.dart';

class AddToCartResponse {
  final ProductEntity product;
  final int cartItemId;
  final int count;

  AddToCartResponse(this.product, this.cartItemId, this.count);

  AddToCartResponse.fromJson(Map<String, dynamic> json)
      : product = ProductEntity.fromJson(json['product']),
        cartItemId = json['id'],
        count = json['quantity'];
}
