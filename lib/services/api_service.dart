import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/api_constants.dart';

/// Thin wrapper around Dio that automatically attaches the JWT auth token
/// and centralizes error handling for every API call in the app.
class ApiService {
  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException e, handler) {
          // TODO: centralize toast/snackbar error display + refresh-token retry
          handler.next(e);
        },
      ),
    );
  }

  static final ApiService instance = ApiService._internal();
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  Future<Response> get(String path, {Map<String, dynamic>? query}) =>
      _dio.get(path, queryParameters: query);

  Future<Response> post(String path, {dynamic data}) => _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) => _dio.put(path, data: data);

  Future<Response> delete(String path, {dynamic data}) => _dio.delete(path, data: data);

  Future<void> saveToken(String token) => _storage.write(key: 'auth_token', value: token);

  Future<void> clearToken() => _storage.delete(key: 'auth_token');
}
