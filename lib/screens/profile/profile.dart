import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pirahesh_shop/screens/auth/auth.dart';
import 'package:pirahesh_shop/screens/profile/comments.dart';
import 'package:pirahesh_shop/screens/profile/fav_products.dart';
import 'package:pirahesh_shop/screens/profile/order.dart';
import 'package:pirahesh_shop/screens/widgets/empty_view.dart';

import '../../data/common/constants.dart';
import '../../data/repo/auth_repository.dart';
import '../../data/repo/profile_repository.dart';
import 'bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileBloc? profileBloc;
  StreamSubscription? stateStreamSubscription;

  @override
  void initState() {
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
    super.initState();
  }

  void authChangeNotifierListener() {
    profileBloc?.add(ProfileAuthInfoChanged(
        authInfo: AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    profileBloc?.close();
    stateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) {
            final bloc = ProfileBloc(profileRepository)
              ..add(ProfileStarted(
                  authInfo: AuthRepository.authChangeNotifier.value));
            stateStreamSubscription = bloc.stream.listen((state) {
              setState(() {});
            });

            return bloc;
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileAuthRequired) {
                return Center(
                  child: EmptyView(
                    message: 'Please sign in to view profile',
                    image: SvgPicture.asset('assets/images/auth_required.svg',
                        width: 120),
                    callToAction: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) => const AuthScreen()));
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ).marginAll(32),
                  ),
                );
              } else
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Profile Information Container
                    if (state is ProfileLoading)
                      MyDecoratedContainer(
                        child: Center(
                            child: CupertinoActivityIndicator(
                          color: Colors.white,
                        )).marginSymmetric(vertical: Constants.primaryPadding),
                        color: themeData.colorScheme.primary,
                      ).marginSymmetric(horizontal: Constants.primaryPadding),
                    if (state is ProfileSuccess)
                      MyDecoratedContainer(
                        color: themeData.colorScheme.primary,
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.person_circle,
                              size: 62,
                              color: themeData.colorScheme.surface,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.user.name,
                                  style: TextStyle(
                                      color: themeData.colorScheme.surface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state.user.phoneNumber,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: themeData.colorScheme.surface
                                          .withOpacity(0.8)),
                                ),
                              ],
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                // Handle edit button
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: themeData.colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                    borderRadius: Constants.primaryRadius),
                                side: BorderSide(
                                  width: 1,
                                  color: themeData.colorScheme.surface,
                                ),
                              ),
                              child: Text(
                                'Edit',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ).marginOnly(right: 6)
                          ],
                        ),
                      ).marginSymmetric(horizontal: Constants.primaryPadding),

                    // Divider
                    MyDivider()
                        .marginSymmetric(horizontal: Constants.primaryPadding),

                    // Profile options and other tiles
                    DrawerTile(
                      title: 'Orders',
                      icon: Icons.shopping_bag,
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => OrderScreen()));
                      },
                    ),
                    DrawerTile(
                      title: 'Comments',
                      icon: Icons.comment,
                      isEven: true,
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => UserComments(),
                            ));
                      },
                    ),
                    DrawerTile(
                      title: 'Favorite Products',
                      icon: CupertinoIcons.heart_fill,
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => FavProductsScreen(),
                        ));
                      },
                    ),
                    DrawerTile(
                      title: 'Logout',
                      icon: Icons.logout,
                      isLogOut: true,
                      onTap: () {
                        authRepository.signOut();
                      },
                    ),
                  ],
                );
            },
          ),
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    this.isEven = false,
    this.isLogOut = false,
    required this.title,
    required this.icon,
    required this.onTap,
  });
  final bool isEven;
  final bool isLogOut;

  final String title;
  final IconData icon;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return ListTile(
      tileColor: isEven
          ? themeData.colorScheme.primary.withOpacity(0.1)
          : isLogOut
              ? themeData.colorScheme.error.withOpacity(0.2)
              : null,
      title: Text(
        title,
        style: TextStyle(
          color: isLogOut ? themeData.colorScheme.errorContainer : null,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          wordSpacing: -2,
        ),
      ),
      leading: Icon(
        icon,
        size: 22,
        color: isLogOut
            ? themeData.colorScheme.errorContainer
            : themeData.colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Divider(color: themeData.colorScheme.secondary.withOpacity(0.5))
        .marginSymmetric(vertical: 16, horizontal: 4);
  }
}

class MyDecoratedContainer extends StatelessWidget {
  const MyDecoratedContainer({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.isOutlined = false,
  });

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).colorScheme;
    return Container(
      padding: padding ?? EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: isOutlined ? null : Constants.primaryBoxShadow(context),
        borderRadius: BorderRadius.circular(6.0),
        color: isOutlined ? themeData.surface : color ?? themeData.surface,
        border: isOutlined
            ? Border.all(width: 1.5, color: color ?? themeData.primary)
            : null,
      ),
      child: child,
    );
  }
}
