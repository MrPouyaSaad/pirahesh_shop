import 'dart:developer';

import 'package:dio/dio.dart';

import '../model/add_to_cart_response.dart';
import '../model/cart_response.dart';

abstract class ICartDataSource {
  Future<AddToCartResponse> add(int productId);
  Future<AddToCartResponse> increase(int productId);
  Future<AddToCartResponse> decrease(int productId);
  Future<void> delete(int productId);
  Future<void> clear();
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRemoteDataSource implements ICartDataSource {
  final Dio httpClient;

  CartRemoteDataSource(this.httpClient);

  @override
  Future<AddToCartResponse> add(int productId) async {
    final response =
        await httpClient.post('cart/add', data: {"productId": productId});

    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<AddToCartResponse> increase(int productId) async {
    final response =
        await httpClient.put('cart/increase', data: {"productId": productId});
    log("Res :" + response.data.toString());

    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<int> count() async {
    final response = await httpClient.get('cart/count');
    return response.data;
  }

  @override
  Future<void> delete(int productId) async {
    await httpClient.delete('cart/remove', data: {'productId': productId});
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpClient.get('cart/items');
    return CartResponse.fromJson(response.data);
  }

  @override
  Future<AddToCartResponse> decrease(int productId) async {
    final response =
        await httpClient.put('cart/decrease', data: {"productId": productId});

    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<void> clear() async {
    await httpClient.delete('cart/clear');
  }
}
