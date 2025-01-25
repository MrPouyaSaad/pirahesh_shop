import 'package:flutter/material.dart';

import '../../common/http_client.dart';
import '../model/add_to_cart_response.dart';
import '../model/cart_response.dart';
import '../source/cart_data_source.dart';

final cartRepository = CartRepository(CartRemoteDataSource(httpClient));

abstract class ICartRepository extends ICartDataSource {}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  static ValueNotifier<int> cartItemCountNotifier = ValueNotifier(0);

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(int productId) => dataSource.add(productId);

  @override
  Future<AddToCartResponse> increase(int productId) {
    return dataSource.increase(productId);
  }

  @override
  Future<int> count() async {
    final count = await dataSource.count();
    cartItemCountNotifier.value = count;
    return count;
  }

  @override
  Future<void> delete(int productId) {
    return dataSource.delete(productId);
  }

  @override
  Future<CartResponse> getAll() => dataSource.getAll();

  @override
  Future<AddToCartResponse> decrease(int productId) {
    return dataSource.decrease(productId);
  }

  @override
  Future<void> clear() {
    return dataSource.clear();
  }
}
