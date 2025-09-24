import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
    : _model = GenerativeModel(
        model: 'gemini-1.5-flash', // modelo rápido e gratuito
        apiKey: apiKey,
      );

  Future<String> gerarResposta(String prompt) async {
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? "Não recebi resposta da IA.";
  }
}
