import 'package:pirahesh_shop/data/model/product.dart';

class Fav {
  int id;
  ProductEntity productEntity;

  Fav.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        productEntity = ProductEntity.fromJson(json['product']);
}
