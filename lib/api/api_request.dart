/// ApiRequest é um enum que contém os métodos HTTP que podem ser utilizados em uma requisição.
enum ApiRequest {
  get,
  post,
  put,
  patch,
  delete,
  head,
  options,
}

extension ApiRequestExtension on ApiRequest {
  String get type {
    switch (this) {
      case ApiRequest.get:
        return 'GET';
      case ApiRequest.post:
        return 'POST';
      case ApiRequest.put:
        return 'PUT';
      case ApiRequest.patch:
        return 'PATCH';
      case ApiRequest.delete:
        return 'DELETE';
      case ApiRequest.head:
        return 'HEAD';
      case ApiRequest.options:
        return 'OPTIONS';
    }
  }
}