import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/gemini_service.dart';

class PromptPadraoController {
  final formKey = GlobalKey<FormState>();
  final papelController = TextEditingController();
  final contextoController = TextEditingController();
  final objetivoController = TextEditingController();
  final detalhesController = TextEditingController();
  final formatoController = TextEditingController();
  final tomController = TextEditingController();
  final exemploController = TextEditingController();
  ValueNotifier<bool> errorPrompt = GeminiService.errorPrompt;
  String prompt = "";

  String? respostaIA;
  bool carregando = false;

  final gemini = GeminiService();

  Future<void> gerarPromptEChamarIA() async {
    List<String?> partes = [
      papelController.text.isNotEmpty
          ? "Atue como: ${papelController.text}"
          : null,
      contextoController.text.isNotEmpty
          ? "Contexto: ${contextoController.text}"
          : null,
      objetivoController.text.isNotEmpty
          ? "Objetivo: ${objetivoController.text}"
          : null,
      detalhesController.text.isNotEmpty
          ? "Detalhes/Regras: ${detalhesController.text}"
          : null,
      formatoController.text.isNotEmpty
          ? "Formato: ${formatoController.text}"
          : null,
      tomController.text.isNotEmpty
          ? "Tom/Estilo: ${tomController.text}"
          : null,
      exemploController.text.isNotEmpty
          ? "Exemplo/Referência: ${exemploController.text}"
          : null,
    ];

    prompt = partes.whereType<String>().join('\n');

    setState(() {
      carregando = true;
      respostaIA = null;
    });

    final resposta = await gemini.gerarResposta(prompt);

    setState(() {
      respostaIA = resposta;
      carregando = false;
    });
  }
}
