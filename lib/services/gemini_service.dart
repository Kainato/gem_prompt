import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:prompt_app/api/http_request.dart';
import 'package:prompt_app/classes/ia_model.dart';
import 'package:prompt_app/main.dart';

import '../api/api_request.dart';

class GeminiService {
  GeminiService();

  static ValueNotifier<bool> errorPrompt = ValueNotifier(false);

  static (TextEditingController, ValueNotifier<String>) selectedModel = (
    TextEditingController(text: "gemini-2.5-flash"),
    ValueNotifier("gemini-2.5-flash"),
  );

  static List<IaModel> modelosDisponiveis = [];

  static List<DropdownMenuEntry<String>> get dropdownModelos {
    return modelosDisponiveis
        .map(
          (model) => DropdownMenuEntry(
            value: model.modelName,
            label: model.displayName,
          ),
        )
        .toList();
  }

  Future<String> gerarResposta(String prompt) async {
    if (modelosDisponiveis.isNotEmpty) {
      modelosDisponiveis.clear();
    }
    try {
      final response = await GenerativeModel(
        model: selectedModel.$1.text,
        apiKey: apiKey,
      ).generateContent([Content.text(prompt)]);
      return response.text ?? "Não recebi resposta da IA.";
    } catch (e, s) {
      errorPrompt.value = true;
      log(
        "Erro ao gerar resposta!",
        error: e,
        stackTrace: s,
        name: "GeminiService • gerarResposta",
      );
      return "Erro ao gerar resposta! Consulte o administrador do projeto para mais detalhes.\nVocê ainda pode copiar o prompt que criou clicando no ícone de cópia no canto superior direito disponibilizado agora!";
    }
  }

  static Future<void> listarModelos(String apiKey) async {
    try {
      final response = await HttpRequest.consume(
        "https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey",
        apiRequest: ApiRequest.get,
      );
      for (var model in response.data['models']) {
        IaModel iaModel = IaModel.fromMap(model);
        modelosDisponiveis.add(iaModel);
      }
    } catch (e, s) {
      log(
        "Erro ao listar modelos!",
        error: e,
        stackTrace: s,
        name: "GeminiService • listarModelos",
      );
    }
  }
}
