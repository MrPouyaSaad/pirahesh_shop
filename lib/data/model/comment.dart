import 'package:pirahesh_shop/data/model/product.dart';

class CommentEntity {
  final int id;
  final String userName;
  final String content;
  final String createdAt;
  final ProductEntity productEntity;

  CommentEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userName = json['userName'],
        content = json['content'],
        createdAt = json['createdAt'],
        productEntity = ProductEntity.fromJson(json['product']);

  static List<CommentEntity> parseJsonArray(List<dynamic> jsonArray) {
    final List<CommentEntity> commentItem = [];
    jsonArray.forEach((element) {
      commentItem.add(CommentEntity.fromJson(element));
    });
    return commentItem;
  }
}
