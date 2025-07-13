
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com', // Sample API base URL
    connectTimeout: const Duration(milliseconds: 5000),
    receiveTimeout: const Duration(milliseconds: 3000),
  )) {
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      // Handle error
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Response> post(String path, {data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      // Handle error
      throw Exception('Failed to post data: $e');
    }
  }

   Future<Response> put(String path, {data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      // Handle error
      throw Exception('Failed to put data: $e');
    }
  }

   Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      // Handle error
      throw Exception('Failed to delete data: $e');
    }
  }
}
