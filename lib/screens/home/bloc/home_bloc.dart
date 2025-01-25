import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pirahesh_shop/data/model/category.dart';
import 'package:pirahesh_shop/data/repo/cat_repo.dart';

import '../../../common/exceptions.dart';
import '../../../data/model/banner.dart';
import '../../../data/model/product.dart';
import '../../../data/repo/banner_repository.dart';
import '../../../data/repo/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IProductRepository productRepository;
  final ICategoryRpository categoryRpository;
  HomeBloc(
      {required this.bannerRepository,
      required this.productRepository,
      required this.categoryRpository})
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        try {
          emit(HomeLoading());
          final banners = await bannerRepository.getAll();
          final recommendedProducts = await productRepository.getRecommend();
          final bestSaleProducts = await productRepository.getBestSale();
          final categories = await categoryRpository.getAll();
          emit(HomeSuccess(
              banners: banners,
              categories: categories,
              recommendedProducts: recommendedProducts,
              bestSaleProducts: bestSaleProducts));
        } catch (e) {
          emit(HomeError(exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
