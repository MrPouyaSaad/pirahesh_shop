import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pirahesh_shop/data/model/cart_response.dart';
import 'package:pirahesh_shop/data/model/order.dart';
import 'package:pirahesh_shop/data/model/user.dart';
import 'package:pirahesh_shop/data/repo/cart_repository.dart';
import 'package:pirahesh_shop/data/repo/profile_repository.dart';

part 'check_out_event.dart';
part 'check_out_state.dart';

class CheckOutBloc extends Bloc<CheckOutEvent, CheckOutState> {
  CheckOutBloc() : super(CheckOutLoading()) {
    on<CheckOutEvent>((event, emit) async {
      if (event is CheckOutScreenStarted) {
        try {
          emit(CheckOutLoading());
          final CartResponse cartResponse = await cartRepository.getAll();
          final User user = await profileRepository.getProfileInfo();
          emit(calculatePriceInfo(cartResponse, user));
        } catch (e) {
          emit(CheckOutError());
        }
      } else if (event is PayButtonClicked) {
        emit(CheckOutSuccess(
            cartResponse: event.cartResponse,
            user: event.user,
            isLoading: true));
        await Future.delayed(Duration(seconds: 2));
        final Order order = await cartRepository.cartCreate();
        await cartRepository.count();
        emit(PayButtonSuccess(order: order));
      }
    });
  }
}

CheckOutSuccess calculatePriceInfo(CartResponse cartResponse, User user) {
  double totalPrice = 0;
  double payablePrice = 0;
  double shippingCost = 0;

  for (var cartItem in cartResponse.cartItems) {
    totalPrice += cartItem.product.price * cartItem.quantity;
    payablePrice += cartItem.product.price * cartItem.quantity;
  }

  shippingCost = 0;

  cartResponse.totalPrice = totalPrice;
  cartResponse.payablePrice = payablePrice + shippingCost;
  cartResponse.shippingCost = shippingCost;

  return CheckOutSuccess(
      cartResponse: cartResponse, user: user, isLoading: false);
}
