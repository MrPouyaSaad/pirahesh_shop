class ProductEntity {
  final int id;
  final String title;
  final String imageUrl;
  final double price;

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['name'],
        imageUrl = json['image'],
        price = json['price'];

  static List<ProductEntity> parseJsonArray(List<dynamic> jsonArray) {
    final List<ProductEntity> productItem = [];
    jsonArray.forEach((element) {
      productItem.add(ProductEntity.fromJson(element));
    });
    return productItem;
  }
}
