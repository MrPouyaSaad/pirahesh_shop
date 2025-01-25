import '../../common/http_client.dart';
import '../model/comment.dart';
import '../source/comment_data_source.dart';

final commentRepository =
    CommentRepository(CommentRemoteDataSource(httpClient));

abstract class ICommentRepository extends ICommentDataSource {}

class CommentRepository implements ICommentRepository {
  final ICommentDataSource dataSource;

  CommentRepository(this.dataSource);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) =>
      dataSource.getAll(productId: productId);

  @override
  Future<void> addComment({required String content, required int productId}) =>
      dataSource.addComment(content: content, productId: productId);

  @override
  Future<List<CommentEntity>> getUserCommernts() =>
      dataSource.getUserCommernts();
}
