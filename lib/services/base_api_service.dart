import 'package:dio/dio.dart';

class BaseApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://worker.pyaesone.com/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  Future<Response?> getRequest(String endpoint,
      {Map<String, dynamic>? params}) async {
    return _handleRequest(() => _dio.get(endpoint, queryParameters: params));
  }

  Future<Response?> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    return _handleRequest(() => _dio.post(endpoint, data: data));
  }

  Future<Response?> postFormRequest(String endpoint, FormData data) async {
    return _handleRequest(() => _dio.post(endpoint, data: data));
  }

  Future<Response?> putRequest(
      String endpoint, Map<String, dynamic> data) async {
    return _handleRequest(() => _dio.put(endpoint, data: data));
  }

  Future<Response?> putFormRequest(String endpoint, FormData data) async {
    return _handleRequest(() => _dio.put(endpoint, data: data));
  }

  Future<Response?> deleteRequest(String endpoint, int id) async {
    return _handleRequest(() => _dio.delete(endpoint, data: {"id": id}));
  }

  Future<Response?> _handleRequest(Future<Response> Function() request) async {
    try {
      return await request();
    } catch (e) {
      if (e is DioException) {
        _handleError(e);
      } else {
        return Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
          statusMessage: 'Unexpected error: $e',
        );
      }
    }
    return null;
  }

  Response _handleError(DioException e) {
    String message;
    int? statusCode;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection Timeout';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive Timeout';
        break;
      case DioExceptionType.badResponse:
        statusCode = e.response?.statusCode;
        message = 'Bad Response: ${e.response?.data['message'] ?? ""}';
        break;
      case DioExceptionType.cancel:
        message = 'Request Cancelled';
        break;
      case DioExceptionType.unknown:
      default:
        message = 'Unexpected Error: ${e.message}';
        break;
    }

    return Response(
      requestOptions: e.requestOptions,
      statusCode: statusCode ?? 500,
      statusMessage: message,
    );
  }
}
