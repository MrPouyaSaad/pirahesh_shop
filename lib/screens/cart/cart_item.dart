import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pirahesh_shop/common/utils.dart';
import 'package:pirahesh_shop/data/common/constants.dart';

import '../../data/model/cart_item.dart';
import '../widgets/image.dart';

class CartItem extends StatelessWidget {
  const CartItem(
      {Key? key,
      required this.data,
      required this.onDeleteButtonClick,
      required this.onIncreaseButtonClick,
      required this.onDecreaseButtonClick})
      : super(key: key);

  final CartItemEntity data;
  final GestureTapCallback onDeleteButtonClick;
  final GestureTapCallback onIncreaseButtonClick;
  final GestureTapCallback onDecreaseButtonClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ImageLoadingService(
                    imageUrl: Constants.baseImageUrl + data.product.imageUrl,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.product.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Quantity'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            onIncreaseButtonClick();
                          },
                          icon: const Icon(CupertinoIcons.plus_rectangle),
                        ),
                        data.changeCountLoading
                            ? CupertinoActivityIndicator(
                                color: Theme.of(context).colorScheme.onSurface,
                              )
                            : Text(
                                data.quantity.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                        IconButton(
                          onPressed: onDecreaseButtonClick,
                          icon: const Icon(CupertinoIcons.minus_rectangle),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   data.product.previousPrice.withPriceLabel,
                    //   style: const TextStyle(
                    //       fontSize: 12,
                    //       color: LightThemeColors.secondaryTextColor,
                    //       decoration: TextDecoration.lineThrough),
                    // ),
                    Text(
                      data.product.price.withPriceLabel,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          data.deleteButtonLoading
              ? const SizedBox(
                  height: 48,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : TextButton(
                  onPressed: onDeleteButtonClick,
                  style: TextButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 16, color: Colors.redAccent[900]),
                    foregroundColor: Colors.redAccent[900],
                  ),
                  child: data.deleteButtonLoading
                      ? CupertinoActivityIndicator()
                      : Text(
                          'Remove',
                        ),
                ),
        ],
      ),
    );
  }
}
