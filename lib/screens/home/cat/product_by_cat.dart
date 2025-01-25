import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pirahesh_shop/data/model/category.dart';
import 'package:pirahesh_shop/data/repo/product_repository.dart';
import 'package:pirahesh_shop/screens/home/cat/bloc/product_by_cat_bloc.dart';
import 'package:pirahesh_shop/screens/product/product.dart';

class ProductByCat extends StatelessWidget {
  const ProductByCat({super.key, required this.category});
  final Category category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: BlocProvider(
        create: (context) => ProductByCatBloc(productRepository)
          ..add(ProductByCatStarted(id: category.id)),
        child: BlocBuilder<ProductByCatBloc, ProductByCatState>(
          builder: (context, state) {
            if (state is ProductByCatLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProductByCatSuccess)
              return SafeArea(child: ProductList(products: state.products));
            else if (state is ProductByCatError) {
              return Center(child: Text('Error in loading products'));
            } else {
              throw UnimplementedError();
            }
          },
        ),
      ),
    );
  }
}
