import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../common/exceptions.dart';
import '../../../data/model/auth_info.dart';
import '../../../data/model/cart_response.dart';
import '../../../data/repo/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItems(emit, event.isRefreshing);
        }
      } else if (event is CartClearButtonClicked) {
        try {
          await cartRepository.clear();
          emit(CartEmpty());
        } catch (e) {
          debugPrint(e.toString());
        }
      } else if (event is CartDeleteButtonClicked) {
        try {
          int productID = 0;

          productID = event.cartItemId;

          for (var cartItem in (state as CartSuccess).cartResponse.cartItems) {
            if (cartItem.id == productID) {
              cartItem.deleteButtonLoading = true;
              productID = cartItem.product.id;

              break;
            }
          }
          emit(CartSuccess((state as CartSuccess).cartResponse));
          await Future.delayed(Duration(seconds: 2));
          await cartRepository.delete(productID);
          final cartResponse = await cartRepository.getAll();
          if (cartResponse.cartItems.isEmpty) {
            emit(CartEmpty());
          } else {
            emit(calculatePriceInfo(cartResponse));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else if (event is CartAuthInfoChanged) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await loadCartItems(emit, false);
          }
        }
      } else if (event is CartIncreaseCountButtonClicked) {
        int productID = 0;

        productID = event.cartItemId;

        for (var cartItem in (state as CartSuccess).cartResponse.cartItems) {
          if (cartItem.id == productID) {
            cartItem.changeCountLoading = true;
            productID = cartItem.product.id;
            break;
          }
        }
        emit(CartSuccess((state as CartSuccess).cartResponse));
        await Future.delayed(Duration(seconds: 2));

        await cartRepository.increase(productID);
        emit(calculatePriceInfo(await cartRepository.getAll()));
      } else if (event is CartDecreaseCountButtonClicked) {
        int productID = 0;

        productID = event.cartItemId;

        for (var cartItem in (state as CartSuccess).cartResponse.cartItems) {
          if (cartItem.id == productID) {
            cartItem.changeCountLoading = true;
            productID = cartItem.product.id;

            break;
          }
        }
        emit(CartSuccess((state as CartSuccess).cartResponse));
        await Future.delayed(Duration(seconds: 2));

        await cartRepository.decrease(productID);
        emit(calculatePriceInfo(await cartRepository.getAll()));
      }
    });
  }

  Future<void> loadCartItems(Emitter<CartState> emit, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emit(CartLoading());
      }
      // await Future.delayed(const Duration(milliseconds: 2000));
      final result = await cartRepository.getAll();
      if (result.cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(calculatePriceInfo(result));
      }
    } catch (e) {
      emit(CartError(AppException()));
    }
  }

  CartSuccess calculatePriceInfo(CartResponse cartResponse) {
    double totalPrice = 0;
    double payablePrice = 0;
    double shippingCost = 0;

    for (var cartItem in cartResponse.cartItems) {
      totalPrice += cartItem.product.price * cartItem.quantity;
      payablePrice += cartItem.product.price * cartItem.quantity;
    }

    shippingCost = payablePrice >= 1000 ? 0 : 15;

    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice + shippingCost;
    cartResponse.shippingCost = shippingCost;

    return CartSuccess(cartResponse);
  }
}
