import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:prompt_app/api/api_request.dart';

/// Classe que consome as requisições HTTP. Ela é responsável por fazer as requisições
/// HTTP para o servidor, tratar os erros e dar as respostas esperadas.
class HttpRequest {
  /// Função que consome as requisições HTTP.
  /// ### Parâmetros
  /// - `route` é a rota da requisição. Não precisa da URL base, pois ela é definida
  /// automaticamente. Exemplo: `profissional/listagem/${Id}`.
  /// - `apiRequest` é o tipo de requisição que será feita.
  /// - `body` é o corpo da requisição. Ele é um Map<String, dynamic> e é opcional.
  /// - `sendTimeout` é o tempo de envio da requisição. O padrão é 30 segundos.
  /// - `receiveTimeout` é o tempo de recebimento da requisição. O padrão é 30 segundos.
  static Future<Response> consume(
    String route, {
    required ApiRequest apiRequest,
    Map<String, dynamic> body = const {},
    int sendTimeout = 30,
    int receiveTimeout = 30,
    bool showDataSendLog = false,
    bool showInterceptorLog = false,
    bool isFormData = false,
    String getToken = '',
    // bool showStatusLog = false,
  }) async {
    // Instanciando o logger
    Logger logger = Logger(
      filter: null,
      output: null,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 0,
        lineLength: 35,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.none,
      ),
    );

    // Instanciando o Dio
    final Dio dio = Dio();

    // Adicionando um interceptor de log. Ele serve para logar as requisições HTTP
    // e suas respectivas respostas e erros
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          if (showInterceptorLog) {
            logger.e(
              'Error[${e.response?.statusCode}] => MESSAGE: ${e.message}',
              error: 'HttpRequest | onError',
            );
          }
          return handler.next(e); // continue
        },
      ),
    );

    // Função auxiliar para realizar a requisição e tratar erros
    Future<Response> makeRequest(Future<Response> Function() request) async {
      try {
        final response = await request();
        return response;
      } on DioException catch (e) {
        if (e.response != null) {
          // Tratar erros que possuem resposta (ex: 404, 500, etc.)
          return Response(
            requestOptions: RequestOptions(
              path: e.response!.statusCode.toString(),
            ),
            statusCode: e.response!.statusCode,
            data: e.response!.data,
            statusMessage: e.response!.data['message'] ?? '',
          );
        } else {
          // Tratar erros que não possuem resposta (ex: problemas de rede)
          return Response(
            requestOptions: RequestOptions(path: '0'),
            statusCode: e.response?.statusCode ?? 0,
            data: e.response?.data ?? 'Erro não identificado!',
            statusMessage:
                '${e.response?.statusCode ?? 0} - Não foi possível identificar o erro!',
          );
        }
      }
    }

    // Variável que segura a resposta da requisição
    late Response? response;

    // Variável que segura a duração da requisição de envio
    Duration sendDuration = Duration(seconds: sendTimeout);

    // Variável que segura a duração da requisição de recebimento
    Duration receiveDuration = Duration(seconds: receiveTimeout);

    // Verificando qual tipo de requisição foi escolhida
    switch (apiRequest) {
      case ApiRequest.delete:
        response = await makeRequest(
          () => dio.delete(
            route,
            data: body,
            options: Options(
              sendTimeout: body.isEmpty ? null : sendDuration,
              receiveTimeout: body.isEmpty ? null : receiveDuration,
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                if (getToken.isNotEmpty) "Authorization": "Bearer $getToken",
              },
            ),
          ),
        );
        break;
      case ApiRequest.get:
        response = await makeRequest(
          () => dio.get(
            route,
            queryParameters: body,
            options: Options(
              sendTimeout: kIsWeb ? null : sendDuration,
              receiveTimeout: kIsWeb ? null : receiveDuration,
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                if (getToken.isNotEmpty) "Authorization": "Bearer $getToken",
              },
            ),
          ),
        );
        break;
      case ApiRequest.post:
        if (isFormData) {
          response = await makeRequest(
            () => dio.post(
              route,
              data: FormData.fromMap(body),
              options: Options(
                sendTimeout: body.isEmpty ? null : sendDuration,
                receiveTimeout: body.isEmpty ? null : receiveDuration,
                contentType: 'multipart/form-data',
                headers: {
                  "Content-Type": "multipart/form-data",
                  "Accept": "multipart/form-data",
                  if (getToken.isNotEmpty) "Authorization": "Bearer $getToken",
                },
              ),
            ),
          );
        } else {
          response = await makeRequest(
            () => dio.post(
              route,
              data: body,
              options: Options(
                sendTimeout: body.isEmpty ? null : sendDuration,
                receiveTimeout: body.isEmpty ? null : receiveDuration,
                headers: {
                  "Content-Type": "application/json",
                  "Accept": "application/json",
                  if (getToken.isNotEmpty) "Authorization": "Bearer $getToken",
                },
              ),
            ),
          );
        }
        break;
      case ApiRequest.put:
        response = await makeRequest(
          () => dio.put(
            route,
            data: body,
            options: Options(
              sendTimeout: body.isEmpty ? null : sendDuration,
              receiveTimeout: body.isEmpty ? null : receiveDuration,
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                if (getToken.isNotEmpty) "Authorization": "Bearer $getToken",
              },
            ),
          ),
        );
        break;
      default:
        log(
          'ApiRequest não encontrada ou não configurada!',
          name: 'HttpRequest | consume',
        );
        break;
    }

    // Retornando a resposta da requisição
    return response!;
  }
}
