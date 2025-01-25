import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pirahesh_shop/screens/product/product.dart';
import 'package:pirahesh_shop/screens/profile/bloc/profile_bloc.dart';

import '../../data/repo/profile_repository.dart';
import '../widgets/empty_view.dart';

class FavProductsScreen extends StatelessWidget {
  const FavProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Products'),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              ProfileBloc(profileRepository)..add(ProfileFavProductsStarted()),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading ||
                  state is ProfileFavProfuctsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ProfileFavProfuctsSuccess) {
                if (state.products.isEmpty) {
                  return Center(
                    child: EmptyView(
                      message: 'No Fav Products!',
                      image: SvgPicture.asset(
                        'assets/images/no_data.svg',
                        width: 124,
                      ),
                    ),
                  );
                } else
                  return ProductList(products: state.products);
              } else if (state is ProfileFavProductsError) {
                return Center(child: Text('Error in loading fav products'));
              } else {
                throw UnimplementedError();
              }
            },
          ),
        ),
      ),
    );
  }
}
