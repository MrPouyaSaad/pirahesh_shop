import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pirahesh_shop/common/utils.dart';
import 'package:pirahesh_shop/data/common/constants.dart';

import '../../data/model/product.dart';
import '../../root.dart';
import '../widgets/image.dart';
import 'details.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.borderRadius,
  });

  final ProductEntity product;
  final BorderRadius borderRadius;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                    product: product,
                  ))),
          child: SizedBox(
            width: 176,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 176,
                      height: 189,
                      child: ImageLoadingService(
                        imageUrl: Constants.baseImageUrl + product.imageUrl,
                        borderRadius: borderRadius,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: favList.contains(product.id)
                              ? const Icon(CupertinoIcons.heart_fill,
                                  color: Colors.red)
                              : Icon(CupertinoIcons.heart)),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                  child: Text(
                    product.price.withPriceLabel,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class ProductList extends StatelessWidget {
  const ProductList({super.key, required this.products});
  final List<ProductEntity> products;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              boxShadow: Constants.primaryBoxShadow(context),
              color: Theme.of(context).colorScheme.surface,
              borderRadius: Constants.primaryRadius,
            ),
            child: Row(
              children: [
                ImageLoadingService(
                  imageUrl: Constants.baseImageUrl + products[index].imageUrl,
                  width: 100,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(products[index].title),
                    SizedBox(height: 16),
                    Text(products[index].price.withPriceLabel),
                  ],
                )
              ],
            ),
          );
        });
  }
}
