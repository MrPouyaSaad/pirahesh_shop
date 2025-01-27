import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../common/http_client.dart';
import '../model/auth_info.dart';
import '../model/user.dart';
import '../source/auth_data_source.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(
  httpClient,
));

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> signUp(User user, String pass);
  Future<void> refreshToken();
  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository(
    this.dataSource,
  );
  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _persistAuthTokens(authInfo);

    log("access token is: ${authInfo.accessToken}");
  }

  @override
  Future<void> signUp(User user, String pass) async {
    final AuthInfo authInfo = await dataSource.signUp(user, pass);
    _persistAuthTokens(authInfo);
    debugPrint("access token is: " + authInfo.accessToken);
  }

  @override
  Future<void> refreshToken() async {
    if (authChangeNotifier.value != null) {
      log('Previous authChangeNotifier value: ${authChangeNotifier.value}');
      final AuthInfo authInfo =
          await dataSource.refreshToken(authChangeNotifier.value!.refreshToken);
      log('New refresh token: ${authInfo.refreshToken}');
      await _persistAuthTokens(authInfo);
      log('AuthChangeNotifier after persisting: ${authChangeNotifier.value}');
    }
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString("access_token", authInfo.accessToken);
    await sharedPreferences.setString("refresh_token", authInfo.refreshToken);
    await loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    log('Loading auth info...');
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken =
        sharedPreferences.getString("access_token") ?? '';
    final String refreshToken =
        sharedPreferences.getString("refresh_token") ?? '';

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(accessToken, refreshToken);
      log('Auth info loaded: ${authChangeNotifier.value}');
    } else {
      authChangeNotifier.value = null;
      log('No valid auth tokens found.');
    }
  }

  @override
  Future<void> signOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();
    authChangeNotifier.value = null;
  }
}
