part of 'product_by_cat_bloc.dart';

sealed class ProductByCatState extends Equatable {
  const ProductByCatState();

  @override
  List<Object> get props => [];
}

final class ProductByCatLoading extends ProductByCatState {}

final class ProductByCatError extends ProductByCatState {}

final class ProductByCatSuccess extends ProductByCatState {
  final List<ProductEntity> products;

  ProductByCatSuccess({required this.products});
}
