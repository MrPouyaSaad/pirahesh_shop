import 'package:pirahesh_shop/common/http_client.dart';

import '../model/comment.dart';
import '../model/fav.dart';
import '../model/order.dart';
import '../model/product.dart';
import '../model/user.dart';
import '../source/profile_data_source.dart';

final profileRepository = ProfileRepository(
    profileDataSource: ProfileDataSource(httpClient: httpClient));

abstract class IProfileRepository {
  Future<User> getProfileInfo();
  Future<User> updateProfile(User user);
  Future<List<Order>> getOrderList();
  Future<List<CommentEntity>> getCommentList();
  Future<List<Fav>> favProductList();
}

class ProfileRepository implements IProfileRepository {
  final IProfileDataSource profileDataSource;

  ProfileRepository({required this.profileDataSource});

  @override
  Future<User> getProfileInfo() async {
    return await profileDataSource.getProfileInfo();
  }

  @override
  Future<List<Fav>> favProductList() async =>
      await profileDataSource.favProductList();

  @override
  Future<List<CommentEntity>> getCommentList() async {
    return await profileDataSource.getCommentList();
  }

  @override
  Future<List<Order>> getOrderList() async {
    return await profileDataSource.getOrderList();
  }

  @override
  Future<User> updateProfile(User user) async {
    return await profileDataSource.updateProfile(user);
  }
}
