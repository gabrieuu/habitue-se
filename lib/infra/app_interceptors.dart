import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Appinterceptors extends QueuedInterceptor {
  //MlogService mlogService = MlogService();
  // final AppStore _appStore = Modular.get<AppStore>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({'Content-Type': 'application/json'});

    // LoginResponse? loginResponse = _appStore.loginResponse;
    // if (loginResponse != null && loginResponse.jwtToken != null) {
    //   options.headers.addAll({
    //     'Authorization': 'Bearer ${loginResponse.jwtToken}',
    //   });
    //   if (loginResponse.unidadeSelecionada != null) {
    //     options.headers.addAll({
    //       'idUnidade': '${loginResponse.unidadeSelecionada!.id}',
    //     });
    //   }
    // }

    _logOnRequest(options);

    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    _logOnError(err);

    //verifica se o erro é de timeout

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.sendTimeout) {
      return handler.next(
        DioException(
          response: Response(
            statusCode: HttpStatus.requestTimeout,
            requestOptions: err.requestOptions,
          ),
          requestOptions: err.requestOptions,
        ),
      );
    }

    // if (err.response?.statusCode == HttpStatus.unauthorized) {
    //   await _appStore.logout();
    // }

    _reportErrorMlog(err);

    return super.onError(err, handler);
  }

  void _reportErrorMlog(DioException err) {
    if (err.requestOptions.data != null &&
        err.requestOptions.data.runtimeType != String) {
      if (err.requestOptions.data.containsKey('anexo')) {
        err.requestOptions.data.remove('anexo');
      }
      if (err.requestOptions.data.containsKey('base64')) {
        err.requestOptions.data.remove('base64');
      }
      if (err.requestOptions.data.containsKey('fotoBase64')) {
        err.requestOptions.data.remove('fotoBase64');
      }
      if (err.requestOptions.data.containsKey('anexos')) {
        err.requestOptions.data.remove('anexos');
      }
      if (err.requestOptions.data.containsKey('login') ||
          err.requestOptions.data.containsKey('password')) {
        err.requestOptions.data.remove('password');
      }
    }
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: err,
        stack: err.stackTrace,
        library: 'DioException',
      ),
    );
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log('onResponse: $response');
    return handler.next(response);
  }

  void _logOnRequest(RequestOptions options) {
    Map<String, dynamic> requestLog = {
      options.method: '${options.uri}',
      'data': '${options.data}',
      'headers': '${options.headers}',
    };
    developer.log('onRequest: $requestLog');
  }

  void _logOnError(DioException err) {
    Map<String, dynamic> errorLog = {
      'requestOptions.method': err.requestOptions.method,
      'requestOptions.baseUrl': err.requestOptions.baseUrl,
      'response.requestOptions.path': err.response?.requestOptions.path,
      'requestOptions.queryParameters': err.requestOptions.queryParameters,
      'requestOptions.headers': err.requestOptions.headers,
      'response.headers': err.response?.headers,
      'response.data': err.response?.data,
      'response.statusCode': err.response?.statusCode,
      'err.stackTrace': err.stackTrace.toString(),
      'requestOptions.data': err.requestOptions.data,
    };
    developer.log('onError: $errorLog');
  }
}