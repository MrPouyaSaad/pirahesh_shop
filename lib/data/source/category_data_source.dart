import 'package:dio/dio.dart';
import 'package:pirahesh_shop/data/model/category.dart';
import 'package:pirahesh_shop/data/common/http_response_validator.dart';

abstract class ICategoryDataSource {
  Future<List<Category>> getAll();
}

class CategoryDataSource
    with HttpResponseValidator
    implements ICategoryDataSource {
  final Dio httpClient;

  CategoryDataSource(this.httpClient);
  @override
  Future<List<Category>> getAll() async {
    final response = await httpClient.get('public/categories');
    validateResponse(response);
    final List<Category> categories = [];
    (response.data as List).forEach((jsonObject) {
      categories.add(Category.fromJson(jsonObject));
    });
    return categories;
  }
}
