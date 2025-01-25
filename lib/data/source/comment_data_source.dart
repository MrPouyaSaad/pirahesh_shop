import 'package:dio/dio.dart';

import '../model/comment.dart';
import '../common/http_response_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
  Future<List<CommentEntity>> getUserCommernts();
  Future<void> addComment({required String content, required int productId});
}

class CommentRemoteDataSource
    with HttpResponseValidator
    implements ICommentDataSource {
  final Dio httpClient;

  CommentRemoteDataSource(this.httpClient);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) async {
    final response = await httpClient.get('products/comments/$productId');
    validateResponse(response);
    final List<CommentEntity> comments = [];
    (response.data as List).forEach((element) {
      comments.add(CommentEntity.fromJson(element));
    });
    return comments;
  }

  @override
  Future<List<CommentEntity>> getUserCommernts() async {
    final res = await httpClient.get('products/comments');
    final List<CommentEntity> comments = [];
    (res.data as List).forEach((element) {
      comments.add(CommentEntity.fromJson(element));
    });
    return comments;
  }

  @override
  Future<void> addComment(
      {required String content, required int productId}) async {
    await httpClient.post('products/comments',
        data: {"content": content, "productId": productId});
  }
}
