import 'package:dio/dio.dart';
import 'package:pirahesh_shop/data/common/constants.dart';

import '../data/repo/auth_repository.dart';

final String clientSecret = 'R9dC1bK28jFq7kNzZxXpU5vL1nT8bM0qWjS9sU2kK6tA0mBz';
final httpClient = Dio(BaseOptions(baseUrl: Constants.baseUrl))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final authInfo = AuthRepository.authChangeNotifier.value;
      if (authInfo != null && authInfo.accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer ${authInfo.accessToken}';
      }
      options.headers['Client-Secret'] = clientSecret;

      handler.next(options);
    },
  ));
