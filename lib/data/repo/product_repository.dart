import '../../common/http_client.dart';
import '../model/fav.dart';
import '../model/product.dart';
import '../source/product_data_source.dart';

final productRepository =
    ProductRepository(ProductRemoteDataSource(httpClient));

abstract class IProductRepository extends IProductDataSource {}

class ProductRepository implements IProductRepository {
  final IProductDataSource dataSource;

  ProductRepository(this.dataSource);

  @override
  Future<List<ProductEntity>> getBestSale() => dataSource.getBestSale();

  @override
  Future<List<ProductEntity>> getByCategory(int id) =>
      dataSource.getByCategory(id);

  @override
  Future<List<ProductEntity>> getRecommend() => dataSource.getRecommend();

  @override
  Future<void> addFavProducts(int productId) =>
      dataSource.addFavProducts(productId);

  @override
  Future<List<Fav>> getFavProducts() => dataSource.getFavProducts();

  @override
  Future<void> removeFavProducts(int id) => dataSource.removeFavProducts(id);

  @override
  Future<List<int>> getFavProductsIds() => dataSource.getFavProductsIds();
}
