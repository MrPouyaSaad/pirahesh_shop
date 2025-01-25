import 'package:dio/dio.dart';

import '../model/auth_info.dart';
import '../common/http_response_validator.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<AuthInfo> signUp(String username, String password);
  Future<AuthInfo> refreshToken(String token);
}

class AuthRemoteDataSource
    with HttpResponseValidator
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);
  @override
  Future<AuthInfo> login(String username, String password) async {
    final response = await httpClient.post("auth/login", data: {
      "phoneNumber": username,
      "password": password,
    });

    validateResponse(response);

    return AuthInfo(
        response.data["accessToken"], response.data["refreshToken"]);
  }

  @override
  Future<AuthInfo> refreshToken(String token) async {
    final response = await httpClient.post("auth/token", data: {
      "grant_type": "refresh_token",
      "refresh_token": token,
      "client_id": 2,
      // "client_secret": Constants.clientSecret
    });

    validateResponse(response);

    return AuthInfo(
        response.data["accessToken"], response.data["refreshToken"]);
  }

  @override
  Future<AuthInfo> signUp(String username, String password) async {
    final response = await httpClient.post("auth/register", data: {
      "name": "Pouya",
      "phoneNumber": username,
      "password": password,
      "postalCode": "1234567890",
      "address": "Tabriz, Azad Univercity"
    });
    validateResponse(response);

    return login(username, password);
  }
}
