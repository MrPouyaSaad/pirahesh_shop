import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pirahesh_shop/data/common/constants.dart';
import 'package:pirahesh_shop/screens/widgets/image.dart';

import '../factor/factor.dart';
import '../price_info.dart';
import 'bloc/check_out_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CheckOutBloc();
        bloc.add(CheckOutScreenStarted());
        bloc.stream.listen(
          (state) {
            if (state is PayButtonSuccess) {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(
                builder: (context) => FactorScreen(order: state.order),
              ));
            }
          },
        );
        return bloc;
      },
      child: BlocBuilder<CheckOutBloc, CheckOutState>(
        builder: (context, state) {
          if (state is CheckOutLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is CheckOutSuccess) {
            final userInfo = state.user;
            final cartItems = state.cartResponse.cartItems;

            return Scaffold(
              floatingActionButton: SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    BlocProvider.of<CheckOutBloc>(context).add(PayButtonClicked(
                        cartResponse: state.cartResponse, user: userInfo));
                  },
                  label: state.isLoading
                      ? CupertinoActivityIndicator()
                      : Text('Pay'),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              appBar: AppBar(
                title: const Text('Checkout'),
                centerTitle: true,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Information Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.person, color: Colors.grey),
                                      SizedBox(width: 8),
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(userInfo.name),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.phone, color: Colors.grey),
                                      SizedBox(width: 8),
                                      Text(
                                        'Phone',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(userInfo.phoneNumber),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.location_on,
                                          color: Colors.grey),
                                      SizedBox(width: 8),
                                      Text(
                                        'Address',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(userInfo.address,
                                        textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.local_post_office,
                                          color: Colors.grey),
                                      SizedBox(width: 8),
                                      Text(
                                        'Postal Code',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(userInfo.postalCode),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Cart Items Section
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ImageLoadingService(
                                    imageUrl: Constants.baseImageUrl +
                                        item.product.imageUrl,
                                    width: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'x${item.quantity}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        // Price Info Section
                        PriceInfo(
                          payablePrice: state.cartResponse.payablePrice,
                          totalPrice: state.cartResponse.totalPrice,
                          shippingCost: state.cartResponse.shippingCost,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: Text('Something went wrong.')),
            );
          }
        },
      ),
    );
  }
}
