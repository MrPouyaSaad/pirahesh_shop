import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pirahesh_shop/data/model/auth_info.dart';
import 'package:pirahesh_shop/data/repo/auth_repository.dart';
import 'package:pirahesh_shop/data/repo/cart_repository.dart';

import '../../../data/repo/product_repository.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final IProductRepository productRepository;
  final IAuthRepository authRepository;
  final ICartRepository cartRepository;
  SplashBloc(this.productRepository, this.authRepository, this.cartRepository)
      : super(SplashLoading()) {
    on<SplashEvent>((event, emit) async {
      if (event is SplashStarted) {
        try {
          try {
            emit(SplashLoading());
            await authRepository.refreshToken();
          } catch (e) {
            await authRepository.signOut();
            log("Auth Info :" +
                AuthRepository.authChangeNotifier.value.toString());
            emit(SplashAuthError());
            return;
          }
          final list = await productRepository.getFavProductsIds();
          await cartRepository.count();
          emit(SplashSuccess(favList: list));
        } catch (e) {
          emit(SplashError());
        }
      }
    });
  }
}
