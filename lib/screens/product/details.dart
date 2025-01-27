import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pirahesh_shop/common/utils.dart';
import 'package:pirahesh_shop/data/common/constants.dart';
import 'package:pirahesh_shop/data/repo/auth_repository.dart';
import 'package:pirahesh_shop/data/repo/product_repository.dart';
import 'package:pirahesh_shop/root.dart';
import 'package:pirahesh_shop/screens/auth/auth.dart';
import 'package:pirahesh_shop/screens/cart/price_info.dart';
import 'package:pirahesh_shop/screens/product/add_comment.dart';

import '../../data/model/product.dart';
import '../../data/repo/cart_repository.dart';
import '../../theme.dart';
import '../widgets/image.dart';
import 'bloc/product_bloc.dart';
import 'comment/comment_list.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StreamSubscription<ProductState>? stateSubscription;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  @override
  void dispose() {
    stateSubscription?.cancel();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository, productRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccess) {
              _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text('Successfully added to the cart')));
            } else if (state is ProductAddToCartError) {
              _scaffoldKey.currentState?.showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) => Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                child: FloatingActionButton.extended(
                  backgroundColor:
                      AuthRepository.authChangeNotifier.value == null
                          ? Theme.of(context).colorScheme.secondary
                          : null,
                  onPressed: () {
                    if (AuthRepository.authChangeNotifier.value == null) {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) => AuthScreen(),
                      ))
                          .then((_) {
                        if (mounted) {
                          setState(() {
                            log('Returned from AuthScreen and updated state');
                          });
                        }
                      });
                    } else {
                      BlocProvider.of<ProductBloc>(context)
                          .add(CartAddButtonClick(widget.product.id));
                    }
                  },
                  label: AuthRepository.authChangeNotifier.value == null
                      ? Text('Sign in to add to cart')
                      : state is ProductAddToCartButtonLoading
                          ? CupertinoActivityIndicator(
                              color: Theme.of(context).colorScheme.onSecondary,
                            )
                          : const Text('Add to Cart'),
                ),
              ),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.width * 0.8,
                    flexibleSpace: ImageLoadingService(
                        imageUrl:
                            Constants.baseImageUrl + widget.product.imageUrl),
                    foregroundColor: LightThemeColors.primaryTextColor,
                    actions: [
                      IconButton(
                          onPressed: () {
                            BlocProvider.of<ProductBloc>(context)
                                .add(AddToFavClicked(widget.product.id));
                          },
                          icon: state is ProductAddToFavButtonLoading
                              ? CupertinoActivityIndicator()
                              : favList.contains(widget.product.id)
                                  ? const Icon(CupertinoIcons.heart_fill,
                                      color: Colors.red)
                                  : Icon(CupertinoIcons.heart))
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                widget.product.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.product.price.withPriceLabel,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            'You can always count on a classic. The Dunk Low pairs its iconic colour-blocking with premium materials and plush padding for game-changing comfort that lasts. The styling possibilities are endless—how will you wear your Dunks?',
                            style: TextStyle(height: 1.4),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Comments',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                AddCommentScreen(
                                                    product: widget.product)));
                                  },
                                  child: const Text('Add Comment'))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  CommentList(productId: widget.product.id),
                  SliverToBoxAdapter(child: SizedBox(height: 84))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
