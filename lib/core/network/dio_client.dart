import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Client Dio configuré pour l'application GlucoPote
class DioClient {
  DioClient._();

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'GlucoPote-App/1.0',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        error: true,
      ),
    );

    return dio;
  }
}

/// Provider Riverpod global pour l'instance Dio
final dioProvider = Provider<Dio>((ref) {
  return DioClient.createDio();
});
