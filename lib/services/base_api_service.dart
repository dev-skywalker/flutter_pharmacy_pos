import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:get_storage/get_storage.dart';

class BaseApiService {
  final Dio _dio = Dio(BaseOptions(
    //baseUrl: 'https://worker.pyaesone.com/api',
    baseUrl: 'https://ssp-pos.pyaesone.com/api',
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  Future<Response?> getRequest(String endpoint,
      {Map<String, dynamic>? params}) async {
    final box = GetStorage();
    final token = box.read("token");
    if (token == null) {
      Get.offAllNamed("/login");
      return Response(requestOptions: RequestOptions());
    }
    return _handleRequest(() => _dio.get(endpoint,
        queryParameters: params,
        options: Options(headers: {'Authorization': 'Bearer $token'})));
  }

  Future<Response?> postRequestWithoutAuth(
      String endpoint, Map<String, dynamic> data) async {
    return _handleRequest(() => _dio.post(endpoint, data: data));
  }

  Future<Response?> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    final box = GetStorage();
    final token = box.read("token");
    if (token == null) {
      //
      Get.offAllNamed("/login");
      return Response(requestOptions: RequestOptions());
    }
    return _handleRequest(() => _dio.post(endpoint,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'})));
  }

  Future<Response?> postFormRequest(String endpoint, FormData data) async {
    final box = GetStorage();
    final token = box.read("token");
    if (token == null) {
      //
      Get.offAllNamed("/login");
      return Response(requestOptions: RequestOptions());
    }
    return await _dio.post(endpoint,
        data: data,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          'Authorization': 'Bearer $token'
        }));
  }

  Future<Response?> putRequest(
      String endpoint, Map<String, dynamic> data) async {
    final box = GetStorage();
    final token = box.read("token");
    if (token == null) {
      //
      Get.offAllNamed("/login");
      return Response(requestOptions: RequestOptions());
    }
    return _handleRequest(() => _dio.put(endpoint,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'})));
  }

  Future<Response?> putFormRequest(String endpoint, FormData data) async {
    final box = GetStorage();
    final token = box.read("token");
    if (token == null) {
      //
      Get.offAllNamed("/login");
      return Response(requestOptions: RequestOptions());
    }
    return _handleRequest(() => _dio.put(endpoint,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'})));
  }

  Future<Response?> deleteRequest(String endpoint, int id) async {
    final box = GetStorage();
    final token = box.read("token");
    if (token == null) {
      //
      Get.offAllNamed("/login");
      return Response(requestOptions: RequestOptions());
    }
    return _handleRequest(() => _dio.delete(endpoint,
        data: {"id": id},
        options: Options(headers: {'Authorization': 'Bearer $token'})));
  }

  Future<Response?> deleteRequestImage(String endpoint, String id) async {
    final box = GetStorage();
    final token = box.read("token");
    if (token == null) {
      //
      Get.offAllNamed("/login");
      return Response(requestOptions: RequestOptions());
    }
    return _handleRequest(() => _dio.delete(endpoint,
        data: {"id": id},
        options: Options(headers: {'Authorization': 'Bearer $token'})));
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
    String? message;
    int? statusCode;

    if (e.response != null) {
      // Server-side error
      message = "Error response: ${e.response?.data}";
      statusCode = e.response?.statusCode;
    } else {
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
    }
    print(statusCode);
    print(message);
    return Response(
      requestOptions: e.requestOptions,
      statusCode: statusCode ?? 500,
      statusMessage: message,
    );
  }
}
