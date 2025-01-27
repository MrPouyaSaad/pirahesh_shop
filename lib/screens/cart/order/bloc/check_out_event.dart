part of 'check_out_bloc.dart';

sealed class CheckOutEvent extends Equatable {
  const CheckOutEvent();

  @override
  List<Object> get props => [];
}

class CheckOutScreenStarted extends CheckOutEvent {}

class PayButtonClicked extends CheckOutEvent {
  final CartResponse cartResponse;
  final User user;

  PayButtonClicked({required this.cartResponse, required this.user});
  @override
  List<Object> get props => [user, cartResponse];
}
