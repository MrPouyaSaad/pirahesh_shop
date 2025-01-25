part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState(this.isLogin);
  final bool isLogin;
  @override
  List<Object> get props => [isLogin];
}

final class AuthInitial extends AuthState {
  const AuthInitial(super.isLogin);
}

final class AuthLoading extends AuthState {
  const AuthLoading(super.isLogin);
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(super.isLogin);
}

final class AuthError extends AuthState {
  final AppException exception;
  const AuthError(super.isLogin, this.exception);
  @override
  List<Object> get props => [exception];
}
