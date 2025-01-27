import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pirahesh_shop/data/model/cart_response.dart';
import 'package:pirahesh_shop/screens/cart/order/checkout_screen.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../data/repo/auth_repository.dart';
import '../../data/repo/cart_repository.dart';
import '../auth/auth.dart';
import '../widgets/empty_view.dart';
import 'bloc/cart_bloc.dart';
import 'cart_item.dart';
import 'price_info.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  StreamSubscription? stateStreamSubscription;
  final RefreshController _refreshController = RefreshController();
  bool stateIsSuccess = false;
  bool isEmpty = true;

  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
    log(AuthRepository.authChangeNotifier.value.toString());
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    stateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        appBar: AppBar(
          centerTitle: true,
          leading: !isEmpty
              ? IconButton(
                  onPressed: () {
                    CartBloc(cartRepository).add(CartClearButtonClicked());
                  },
                  icon: Icon(
                    CupertinoIcons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ))
              : null,
          title: const Text('Cart'),
        ),
        floatingActionButton: Visibility(
          visible: stateIsSuccess,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 48, right: 48),
            child: FloatingActionButton.extended(
                onPressed: () {
                  final state = cartBloc!.state;

                  if (state is CartSuccess) {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => CheckoutScreen(),
                        ));
                  }
                },
                label: const Text('Checkout')),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocProvider<CartBloc>(
          create: (context) {
            final bloc = CartBloc(cartRepository);
            bloc.stream.listen((state) {
              if (state is CartEmpty) {
                setState(() {});
              }
            });
            stateStreamSubscription = bloc.stream.listen((state) {
              setState(() {
                stateIsSuccess = state is CartSuccess;
              });

              if (_refreshController.isRefresh) {
                if (state is CartSuccess || state is CartEmpty) {
                  _refreshController.refreshCompleted();
                } else if (state is CartError) {
                  _refreshController.refreshFailed();
                }
              }
            });
            cartBloc = bloc;
            bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CartError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(state.exception.message),
                      ElevatedButton(
                          onPressed: () {
                            cartBloc?.add(CartStarted(
                                AuthRepository.authChangeNotifier.value));
                          },
                          child: const Text('Retry'))
                    ],
                  ),
                );
              } else if (state is CartSuccess) {
                isEmpty = false;

                return SmartRefresher(
                  controller: _refreshController,
                  header: const ClassicHeader(
                    completeText: 'Refresh Completed',
                    refreshingText: 'Refreshing...',
                    idleText: 'Pull to refresh',
                    releaseText: 'Release to refresh',
                    failedText: 'Refresh Failed',
                    spacing: 4,
                    refreshingIcon: CupertinoActivityIndicator(),
                    completeIcon: Icon(
                      CupertinoIcons.checkmark_circle,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  onRefresh: () {
                    cartBloc?.add(CartStarted(
                        AuthRepository.authChangeNotifier.value,
                        isRefreshing: true));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                        bottom: 80, left: 12, right: 12, top: 16),
                    itemBuilder: (context, index) {
                      if (index < state.cartResponse.cartItems.length) {
                        final data = state.cartResponse.cartItems[index];
                        return CartItem(
                          data: data,
                          onDeleteButtonClick: () {
                            cartBloc?.add(CartDeleteButtonClicked(data.id));
                          },
                          onDecreaseButtonClick: () {
                            if (data.quantity > 1) {
                              cartBloc?.add(
                                  CartDecreaseCountButtonClicked(data.id));
                            }
                          },
                          onIncreaseButtonClick: () {
                            cartBloc
                                ?.add(CartIncreaseCountButtonClicked(data.id));
                          },
                        );
                      } else {
                        return PriceInfo(
                          payablePrice: state.cartResponse.payablePrice,
                          totalPrice: state.cartResponse.totalPrice,
                          shippingCost: state.cartResponse.shippingCost,
                        );
                      }
                    },
                    itemCount: state.cartResponse.cartItems.length + 1,
                  ),
                );
              } else if (state is CartAuthRequired) {
                isEmpty = true;

                return EmptyView(
                    message: 'Please sign in to see your cart!',
                    callToAction: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) => const AuthScreen()));
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ).marginAll(32),
                    image: SvgPicture.asset(
                      'assets/images/auth_required.svg',
                      width: 120,
                    ));
              } else if (state is CartEmpty) {
                isEmpty = true;
                return SmartRefresher(
                  controller: _refreshController,
                  header: const ClassicHeader(
                    completeText: 'Refresh Completed',
                    refreshingText: 'Refreshing...',
                    idleText: 'Pull to refresh',
                    releaseText: 'Release to refresh',
                    failedText: 'Refresh Failed',
                    spacing: 4,
                    refreshingIcon: CupertinoActivityIndicator(),
                  ),
                  onRefresh: () {
                    cartBloc?.add(CartStarted(
                        AuthRepository.authChangeNotifier.value,
                        isRefreshing: true));
                  },
                  child: EmptyView(
                      message:
                          'Your cart is empty! Start adding items to your cart now!',
                      image: SvgPicture.asset(
                        'assets/images/empty_cart.svg',
                        width: 200,
                      )),
                );
              } else {
                throw Exception('current cart state is not valid');
              }
            },
          ),
        ));
  }
}
