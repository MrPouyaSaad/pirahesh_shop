import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pirahesh_shop/data/repo/auth_repository.dart';
import 'package:pirahesh_shop/data/repo/cart_repository.dart';
import 'package:pirahesh_shop/data/repo/product_repository.dart';

import '../../root.dart';
import 'bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isNavigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (mounted) {
        setState(() {
          isNavigated = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isAuthEmpty = AuthRepository.authChangeNotifier.value == null ||
        AuthRepository.authChangeNotifier.value?.accessToken == '';

    if (isNavigated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RootScreen()),
        );
      });
    }

    if (isAuthEmpty) {
      return Scaffold(
        backgroundColor: themeData.colorScheme.surfaceContainerHighest,
        body: SafeArea(
          child: Center(
            child: Image.asset(
              'assets/images/nike_logo.png',
              width: 128,
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: themeData.colorScheme.surfaceContainerHighest,
        body: BlocProvider(
          create: (context) {
            final bloc =
                SplashBloc(productRepository, authRepository, cartRepository);
            bloc.stream.forEach((state) {
              if (state is SplashSuccess) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const RootScreen()),
                );
              }
            });
            return bloc..add(SplashStarted());
          },
          child: BlocBuilder<SplashBloc, SplashState>(
            builder: (context, state) {
              if (state is SplashLoading || state is SplashSuccess) {
                return SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Image.asset(
                          'assets/images/nike_logo.png',
                          width: 128,
                        ),
                        const SizedBox(height: 80),
                        const Spacer(),
                        CupertinoActivityIndicator(
                          color: themeData.colorScheme.secondary,
                          radius: 16,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              } else if (state is SplashError) {
                return SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Image.asset(
                          'assets/images/nike_logo.png',
                          width: 128,
                        ),
                        const SizedBox(height: 80),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<SplashBloc>(context)
                                .add(SplashStarted());
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              } else {
                throw UnimplementedError();
              }
            },
          ),
        ),
      );
    }
  }
}
