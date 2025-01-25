import 'package:dio/dio.dart';
import 'package:pirahesh_shop/data/model/comment.dart';
import 'package:pirahesh_shop/data/model/fav.dart';
import 'package:pirahesh_shop/data/model/order.dart';
import 'package:pirahesh_shop/data/model/product.dart';
import 'package:pirahesh_shop/data/model/user.dart';

abstract class IProfileDataSource {
  Future<User> getProfileInfo();
  Future<User> updateProfile(User user);
  Future<List<Order>> getOrderList();
  Future<List<CommentEntity>> getCommentList();
  Future<List<Fav>> favProductList();
}

class ProfileDataSource implements IProfileDataSource {
  final Dio httpClient;

  ProfileDataSource({required this.httpClient});
  @override
  Future<User> getProfileInfo() async {
    final user = await httpClient.get('auth/getInfo');
    return User.fromJson(user.data);
  }

  @override
  Future<List<Fav>> favProductList() async {
    final response = await httpClient.get('favorites');
    final List<dynamic> data = response.data;
    return data.map((json) => Fav.fromJson(json)).toList();
  }

  @override
  Future<List<CommentEntity>> getCommentList() async {
    final response = await httpClient.get('products/comments');
    final List<dynamic> data = response.data;
    return data.map((json) => CommentEntity.fromJson(json)).toList();
  }

  @override
  Future<List<Order>> getOrderList() async {
    final response = await httpClient.get('orders');
    final List<dynamic> data = response.data;
    return data.map((json) => Order.fromJson(json)).toList();
  }

  @override
  Future<User> updateProfile(User user) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
}
