import 'package:flutter/material.dart';

import '../../services/gemini_service.dart';

class TaskCreatorController extends ChangeNotifier {
  TextEditingController inputController = TextEditingController();

  ValueNotifier<bool> loadingInput = ValueNotifier(false);

  final gemini = GeminiService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String baseInput =
      "Me ajude a reformular a seguinte atividade para uma plataforma de 'gestão de atividades'. A sua resposta deve incluir apenas as seguintes informações: um título, uma descrição resumo do que deve ser feito, requisitos técnicos bem elaborados, formas de validação que expliquem como os usuários finais devem testar esta atividade. Além disso, gostaria que a atividade fosse relevante para as práticas ágeis e incluísse aspectos de colaboração em equipe. Segue o contexto da atividade abaixo:\n\n";

  String realInput = "";

  ValueNotifier<String> respostaIA = ValueNotifier("");

  Future<void> gerarPromptEChamarIA() async {
    realInput = baseInput + inputController.text;

    loadingInput.value = true;
    notifyListeners();

    await gemini
        .gerarResposta(realInput)
        .then((value) => respostaIA.value = value)
        .whenComplete(() {
          loadingInput.value = false;
          notifyListeners();
        });
  }

  void resetPrompt() {
    realInput = baseInput;
    notifyListeners();
  }

  Future<void> limparInput() async {
    inputController.clear();
    resetPrompt();
    notifyListeners();
  }
}
