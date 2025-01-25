import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pirahesh_shop/data/repo/product_repository.dart';

import '../../../common/exceptions.dart';
import '../../../data/repo/cart_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository cartRepository;
  final IProductRepository productRepository;
  ProductBloc(this.cartRepository, this.productRepository)
      : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is CartAddButtonClick) {
        try {
          emit(ProductAddToCartButtonLoading());
          await Future.delayed(const Duration(seconds: 2));
          await cartRepository.add(event.productId);
          await cartRepository.count();
          emit(ProductAddToCartSuccess());
        } catch (e) {
          emit(ProductAddToCartError(AppException()));
        }
      } else if (event is AddToFavClicked) {
        try {
          emit(ProductAddToFavButtonLoading());
          await Future.delayed(const Duration(seconds: 2));
          await productRepository.addFavProducts(event.productId);
          await productRepository.getFavProductsIds();
          emit(ProductAddToFavSuccess());
        } catch (e) {
          emit(ProductAddToFavError());
        }
      }
    });
  }
}
