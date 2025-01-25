import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pirahesh_shop/common/utils.dart';

import '../../theme.dart';

class PriceInfo extends StatelessWidget {
  final double payablePrice;
  final double shippingCost;
  final double totalPrice;

  const PriceInfo(
      {Key? key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 8, 0),
          child: Text('Details', style: Theme.of(context).textTheme.titleMedium)
              .marginOnly(left: 8),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 32),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05))
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Price'),
                    RichText(
                        text: TextSpan(
                            text: totalPrice.separateByComma,
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(color: LightThemeColors.secondaryColor),
                            children: const [
                          TextSpan(text: ' \$', style: TextStyle(fontSize: 10))
                        ]))
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Shipping Cost'),
                    Text(shippingCost.withPriceLabel),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Payable Price'),
                    RichText(
                      text: TextSpan(
                        text: payablePrice.separateByComma,
                        style: DefaultTextStyle.of(context).style.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        children: const [
                          TextSpan(
                              text: ' \$',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.normal))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
