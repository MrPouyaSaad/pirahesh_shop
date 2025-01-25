import 'package:dio/dio.dart';
import 'package:pirahesh_shop/root.dart';

import '../common/http_response_validator.dart';
import '../model/fav.dart';
import '../model/product.dart';

abstract class IProductDataSource {
  Future<List<ProductEntity>> getByCategory(int id);
  Future<List<ProductEntity>> getRecommend();
  Future<List<ProductEntity>> getBestSale();

  Future<List<Fav>> getFavProducts();
  Future<List<int>> getFavProductsIds();
  Future<void> addFavProducts(int productId);
  Future<void> removeFavProducts(int id);
}

class ProductRemoteDataSource
    with HttpResponseValidator
    implements IProductDataSource {
  final Dio httpClient;

  ProductRemoteDataSource(this.httpClient);

  @override
  Future<List<ProductEntity>> getBestSale() async {
    final response = await httpClient.get('public/products/best-sellers');
    validateResponse(response);
    final products = <ProductEntity>[];
    (response.data as List).forEach((element) {
      products.add(ProductEntity.fromJson(element));
    });
    return products;
  }

  @override
  Future<List<ProductEntity>> getByCategory(int id) async {
    final response = await httpClient
        .post('public/products/by-category', data: {'categoryId': id});
    validateResponse(response);
    final products = <ProductEntity>[];
    (response.data as List).forEach((element) {
      products.add(ProductEntity.fromJson(element));
    });
    return products;
  }

  @override
  Future<List<ProductEntity>> getRecommend() async {
    final response = await httpClient.get('public/products/recommended');
    validateResponse(response);
    final products = <ProductEntity>[];
    (response.data as List).forEach((element) {
      products.add(ProductEntity.fromJson(element));
    });
    return products;
  }

  @override
  Future<void> addFavProducts(int productId) async {
    await httpClient.post('favorites', data: {"productId": productId});
  }

  @override
  Future<List<Fav>> getFavProducts() async {
    final response = await httpClient.get('favorites');
    final List<dynamic> data = response.data;
    return data.map((json) => Fav.fromJson(json)).toList();
  }

  @override
  Future<void> removeFavProducts(int id) async {
    await httpClient.delete('favorites', data: {"id": id});
  }

  @override
  Future<List<int>> getFavProductsIds() async {
    final response = await httpClient.get('favorites/product-ids');

    List<int> productIds = List<int>.from(response.data.map((e) => e as int));

    favList = productIds;

    return productIds;
  }
}
