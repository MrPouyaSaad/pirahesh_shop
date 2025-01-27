part of 'check_out_bloc.dart';

sealed class CheckOutState extends Equatable {
  const CheckOutState();

  @override
  List<Object> get props => [];
}

final class CheckOutLoading extends CheckOutState {}

final class CheckOutSuccess extends CheckOutState {
  final CartResponse cartResponse;
  final User user;
  final bool isLoading;

  CheckOutSuccess(
      {required this.cartResponse,
      required this.user,
      required this.isLoading});

  @override
  List<Object> get props => [user, cartResponse];
}

final class CheckOutError extends CheckOutState {}

final class PayButtonLoading extends CheckOutState {}

final class PayButtonSuccess extends CheckOutState {
  final Order order;

  PayButtonSuccess({required this.order});
}

final class PayButtonError extends CheckOutState {}
