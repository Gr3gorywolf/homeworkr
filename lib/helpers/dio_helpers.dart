import 'package:dio/dio.dart';
import 'package:homeworkr/stores/stores.dart';

class DioHelpers {
  static Dio get dioInstance {
    Dio instance = new Dio();
    instance.options.connectTimeout = 10000;
    instance.options.receiveTimeout = 15000;
    instance.interceptors.add(_DioInterceptors.headersInterceptor);
    return instance;
  }
}

class _DioInterceptors {
  static InterceptorsWrapper get headersInterceptor =>
      InterceptorsWrapper(onRequest: (RequestOptions opts) async {
        await Stores.userStore.refreshToken();
        var token = Stores.userStore.token;
        if (token != null) {
          opts.headers['Authorization'] = "Bearer $token";
        }
        return opts;
      }, onResponse: (Response res) async {
        if (res.statusCode == 401) {
          Stores.userStore.logout();
        }
      });
}
