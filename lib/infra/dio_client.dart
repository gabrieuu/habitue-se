import 'package:dio/dio.dart';
import 'package:habitue_se/infra/app_interceptors.dart';
import 'package:habitue_se/infra/client_http.dart';

class DioClient implements ClientHttp {

  Dio dio = Dio();

  DioClient(){
    setupDio();
  }

  void setupDio() {
    dio.interceptors.add(
      Appinterceptors()
    );
  }

  @override
  Future<Object> delete(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    ClientHttpOptions? options,
  }) async{
    var response = await dio.delete(path, data: data, queryParameters: queryParameters);
    return response.data;
  }

  @override
  Future<Object> get(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    ClientHttpOptions? options,
  }) async{
    var response = await dio.get(path, queryParameters: queryParameters);
    return response.data;
  }

  @override
  Future<Object> post(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    ClientHttpOptions? options,
  }) async {
    var response = await dio.post(path, data: data, queryParameters: queryParameters);
    return response.data;
  }

  @override
  Future<Object> put(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    ClientHttpOptions? options,
  }) async{
    var response = await dio.put(path, data: data, queryParameters: queryParameters);
    return response.data;
  }


}