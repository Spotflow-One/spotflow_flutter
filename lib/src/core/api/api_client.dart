import 'package:dio/dio.dart';

class ApiClient {
  String? authToken;

  ApiClient(this.authToken);

  Dio get dio => Dio()
    ..interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ))
    ..options = BaseOptions(
      headers: {
        if (authToken != null) 'Authorization': "Bearer $authToken",
      },
    );

  Future<Response> post(String path,
          {Map<String, dynamic>? data, Options? options}) =>
      dio.post(
        path,
        data: data,
        options: options,
      );

  Future get(String path, {Map<String, dynamic>? data, Options? options}) =>
      dio.get(
        path,
        data: data,
        options: options,
      );

  Future delete(String path, {Map<String, dynamic>? data, Options? options}) =>
      dio.delete(
        path,
        data: data,
        options: options,
      );

  Future put(String path, {Map<String, dynamic>? data, Options? options}) =>
      dio.put(
        path,
        data: data,
        options: options,
      );

  Future patch(String path, {Map<String, dynamic>? data, Options? options}) =>
      dio.put(
        path,
        data: data,
        options: options,
      );
}
