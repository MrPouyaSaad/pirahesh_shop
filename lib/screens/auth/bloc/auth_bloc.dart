// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pirahesh_shop/data/model/user.dart';
import 'package:pirahesh_shop/root.dart';

import '../../../common/exceptions.dart';
import '../../../data/repo/auth_repository.dart';
import '../../../data/repo/cart_repository.dart';
import '../../../data/repo/product_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool isLogin;
  final IAuthRepository authRepository;
  final ICartRepository cartRepository;
  AuthBloc({
    this.isLogin = true,
    required this.authRepository,
    required this.cartRepository,
  }) : super(AuthInitial(isLogin)) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthStarted) {
          emit(AuthInitial(isLogin));
        } else if (event is AuthButtonClicked) {
          if (isLogin) {
            emit(AuthLoading(isLogin));
            await authRepository.login(event.username, event.password);
            final list = await productRepository.getFavProductsIds();
            favList = list;
            await cartRepository.count();
            emit(AuthSuccess(isLogin));
          } else {
            emit(AuthLoading(isLogin));

            await authRepository.signUp(event.user!, event.password);
            emit(AuthSuccess(isLogin));
          }
        } else if (event is AuthModeChangeButtonClicked) {
          isLogin = !isLogin;
          emit(AuthInitial(isLogin));
        }
      } catch (e) {
        emit(AuthError(isLogin, AppException()));
      }
    });
  }
}
