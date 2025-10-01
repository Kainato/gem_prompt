enum StatusCode {
  sucesso,
  invalido,
  naoAutorizado,
  inexistente,
  erro,
  proibido,
}

extension StatusCodeExtension on StatusCode {
  String get type {
    switch (this) {
      case StatusCode.sucesso:
        return 'Requisição realizada com sucesso!';
      case StatusCode.invalido:
        return 'Houve um erro ao tentar acessar o recurso solicitado! Por favor, tente novamente.';
      case StatusCode.naoAutorizado:
        return 'Você não tem permissão para acessar este recurso!';
      case StatusCode.inexistente:
        return 'Houve uma tentativa de fazer uma requisição para um recurso com informações inexistentes!';
      case StatusCode.erro:
        return 'Houve um erro interno no servidor! Por favor, tente novamente.';
      case StatusCode.proibido:
        return 'Você não tem permissão para acessar este recurso!';
    }
  }

  String get title {
    switch (this) {
      case StatusCode.sucesso:
        return 'Sucesso 200 - OK!';
      case StatusCode.invalido:
        return 'Erro 400 - Bad Request!';
      case StatusCode.naoAutorizado:
        return 'Erro 401 - Unauthorized!';
      case StatusCode.inexistente:
        return 'Erro 404 - Not Found!';
      case StatusCode.erro:
        return 'Erro 500 - Internal Server Error!';
      case StatusCode.proibido:
        return 'Erro 403 - Forbidden!';
    }
  }

  int get code {
    switch (this) {
      case StatusCode.sucesso:
        return 200;
      case StatusCode.invalido:
        return 400;
      case StatusCode.naoAutorizado:
        return 401;
      case StatusCode.inexistente:
        return 404;
      case StatusCode.erro:
        return 500;
      case StatusCode.proibido:
        return 403;
    }
  }
}
