import 'package:dio/dio.dart';

import '../model/auth_info.dart';
import '../common/http_response_validator.dart';
import '../model/user.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<AuthInfo> signUp(User user, String pass);
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
    final response = await httpClient.post("auth/refresh", data: {
      "refreshToken": token,
    });

    validateResponse(response);

    return AuthInfo(
        response.data["accessToken"], response.data["refreshToken"]);
  }

  @override
  Future<AuthInfo> signUp(User user, String pass) async {
    final response = await httpClient.post("auth/register", data: {
      "name": user.name,
      "phoneNumber": user.phoneNumber,
      "password": pass,
      "postalCode": user.postalCode,
      "address": user.address
    });
    validateResponse(response);

    return login(user.phoneNumber, pass);
  }
}
