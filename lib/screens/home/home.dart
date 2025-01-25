import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:pirahesh_shop/data/common/constants.dart';
import 'package:pirahesh_shop/screens/home/cat/product_by_cat.dart';
import 'package:pirahesh_shop/screens/widgets/image.dart';
import '../../data/model/product.dart';
import '../../data/repo/banner_repository.dart';
import '../../data/repo/cat_repo.dart';
import '../../data/repo/product_repository.dart';
import '../product/product.dart';
import '../widgets/error.dart';
import '../widgets/slider.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
            categoryRpository: categoryRpository,
            bannerRepository: bannerRepository,
            productRepository: productRepository);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(builder: ((context, state) {
            if (state is HomeSuccess) {
              return ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Container(
                          height: 56,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/nike_logo.png',
                            fit: BoxFit.fitHeight,
                            height: 24,
                          ),
                        );
                      case 2:
                        return BannerSlider(
                          banners: state.banners,
                        ).marginSymmetric(vertical: 16);
                      case 3:
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category',
                                style: Theme.of(context).textTheme.titleMedium),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 150,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // Number of items per row
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.7,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: state.categories
                                    .length, // Change this to the dynamic length of your list
                                itemBuilder: (context, index) {
                                  return _buildImageWithTitle(
                                      Constants.baseImageUrl +
                                          state.categories[index].image,
                                      state.categories[index].name, () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ProductByCat(
                                          category: state.categories[index],
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ).marginAll(16);
                      case 4:
                        return _HorizontalProductList(
                          title: 'Recommended',
                          onTap: () {},
                          products: state.recommendedProducts,
                        );
                      case 5:
                        return _HorizontalProductList(
                          title: 'Best sellers',
                          onTap: () {},
                          products: state.bestSaleProducts,
                        );
                      default:
                        return Container();
                    }
                  });
            } else if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return AppErrorWidget(
                exception: state.exception,
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                },
              );
            } else {
              throw Exception('state is not supported');
            }
          })),
        ),
      ),
    );
  }

  Widget _buildImageWithTitle(
      String imagePath, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ImageLoadingService(
              imageUrl: imagePath,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;
  const _HorizontalProductList({
    required this.title,
    required this.onTap,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                  onPressed: onTap,
                  child: Row(
                    children: [
                      const Text('All'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, size: 14)
                    ],
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 8, right: 8),
              itemBuilder: ((context, index) {
                final product = products[index];
                return ProductItem(
                  product: product,
                  borderRadius: BorderRadius.circular(12),
                );
              })),
        )
      ],
    );
  }
}
