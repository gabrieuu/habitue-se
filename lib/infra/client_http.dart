abstract class ClientHttp {
  Future<Object> get(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    ClientHttpOptions? options,
  });
  Future<Object> post(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    ClientHttpOptions? options,
  });
  Future<Object> put(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    ClientHttpOptions? options,
  });
  Future<Object> delete(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    ClientHttpOptions? options,
  });
}


class ClientHttpOptions{

}