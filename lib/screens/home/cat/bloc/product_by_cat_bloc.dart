// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pirahesh_shop/data/model/product.dart';
import 'package:pirahesh_shop/data/repo/product_repository.dart';

part 'product_by_cat_event.dart';
part 'product_by_cat_state.dart';

class ProductByCatBloc extends Bloc<ProductByCatEvent, ProductByCatState> {
  final IProductRepository productRepository;
  ProductByCatBloc(
    this.productRepository,
  ) : super(ProductByCatLoading()) {
    on<ProductByCatEvent>((event, emit) async {
      if (event is ProductByCatStarted) {
        try {
          final products = await productRepository.getByCategory(event.id);
          emit(ProductByCatSuccess(products: products));
        } catch (e) {
          emit(ProductByCatError());
        }
      }
    });
  }
}
