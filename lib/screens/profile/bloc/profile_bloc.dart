import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pirahesh_shop/data/model/fav.dart';

import '../../../data/model/auth_info.dart';
import '../../../data/model/comment.dart';
import '../../../data/model/order.dart';
import '../../../data/model/product.dart';
import '../../../data/model/user.dart';
import '../../../data/repo/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  ProfileBloc(this.profileRepository) : super(ProfileLoading()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ProfileStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(ProfileAuthRequired());
        } else {
          try {
            final user = await profileRepository.getProfileInfo();
            await Future.delayed(Duration(seconds: 1));
            emit(ProfileSuccess(user: user));
          } catch (e) {
            emit(ProfilError());
          }
        }
      } else if (event is ProfileOrderStarted) {
        try {
          emit(ProfileOrderLoading());
          final order = await profileRepository.getOrderList();
          emit(ProfileOrderSuccess(order: order));
        } catch (e) {
          emit(ProfilOrderError());
        }
      } else if (event is ProfileCommentsStarted) {
        try {
          final commentEntity = await profileRepository.getCommentList();
          emit(ProfileCommentsSuccess(comments: commentEntity));
        } catch (e) {
          emit(ProfileCommentsError());
        }
      } else if (event is ProfileFavProductsStarted) {
        try {
          final fav = await profileRepository.favProductList();
          final productEntity = fav.map((e) => e.productEntity).toList();
          emit(ProfileFavProfuctsSuccess(products: productEntity));
        } catch (e) {
          emit(ProfileFavProductsError());
        }
      } else if (event is ProfileAuthInfoChanged) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(ProfileAuthRequired());
        } else {
          if (state is ProfileAuthRequired) {
            try {
              final user = await profileRepository.getProfileInfo();
              await Future.delayed(Duration(seconds: 1));
              emit(ProfileSuccess(user: user));
            } catch (e) {
              emit(ProfilError());
            }
          }
        }
      }
    });
  }
}
