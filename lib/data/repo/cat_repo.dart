import 'package:pirahesh_shop/data/model/category.dart';

import '../../common/http_client.dart';
import '../source/category_data_source.dart';

final categoryRpository = CategoryRpository(CategoryDataSource(httpClient));

abstract class ICategoryRpository {
  Future<List<Category>> getAll();
}

class CategoryRpository implements ICategoryRpository {
  final CategoryDataSource dataSource;

  CategoryRpository(this.dataSource);

  @override
  Future<List<Category>> getAll() => dataSource.getAll();
}
