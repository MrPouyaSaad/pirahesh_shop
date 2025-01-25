part of 'product_by_cat_bloc.dart';

sealed class ProductByCatEvent extends Equatable {
  const ProductByCatEvent();

  @override
  List<Object> get props => [];
}

class ProductByCatStarted extends ProductByCatEvent {
  final int id;

  ProductByCatStarted({required this.id});
}
