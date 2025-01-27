part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthStarted extends AuthEvent {}

final class AuthButtonClicked extends AuthEvent {
  final String username;
  final String password;
  final User? user;

  const AuthButtonClicked(
      {required this.username, required this.password, this.user});

  @override
  List<Object> get props => [username, password];
}

final class AuthModeChangeButtonClicked extends AuthEvent {}
