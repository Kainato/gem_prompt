import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:prompt_app/main.dart';

class ScreenshotService {
  static final ScreenshotService _instance = ScreenshotService._internal();
  factory ScreenshotService() => _instance;
  ScreenshotService._internal();

  GenerativeModel? _model;

  GenerativeModel get model {
    if (_model == null) {
      if (apiKey.isEmpty) {
        throw Exception(
          'API_KEY não configurada. Use --dart-define=API_KEY=sua_chave',
        );
      }
      _model = GenerativeModel(model: 'gemini-2.0-flash-exp', apiKey: apiKey);
    }
    return _model!;
  }

  /// Analisa uma imagem (screenshot) usando Gemini
  Future<String> analyzeScreenshot(Uint8List imageBytes) async {
    try {
      final response = await model.generateContent([
        Content.multi([
          TextPart(
            'Você recebe um screenshot que pode conter uma pergunta ou problema '
            '(pode ser sobre programação, fundamentos de computação, inglês, raciocínio lógico ou qualquer assunto). '
            'Leia cuidadosamente e forneça uma resposta curta, clara e direta. '
            'Se for uma questão de código, retorne APENAS o código correto na linguagem apropriada. '
            'NÃO adicione explicações ou passos. Seja conciso.',
          ),
          DataPart('image/png', imageBytes),
        ]),
      ]);

      return response.text ?? 'Nenhuma resposta recebida';
    } catch (e) {
      rethrow;
    }
  }

  /// Analisa texto extraído
  Future<String> analyzeText(String text) async {
    try {
      final response = await model.generateContent([
        Content.text(
          'Você é um tutor AI especialista. '
          'Resolva ou explique o texto detectado da tela.\n'
          '- Programação: retorne uma solução limpa na linguagem correta.\n'
          '- Teoria/raciocínio/inglês: responda claramente.\n'
          '- Se for texto geral, forneça um resumo útil e curto.\n'
          '- Mantenha as respostas curtas e diretas.\n\n'
          'Texto da tela:\n$text',
        ),
      ]);

      return response.text ?? 'Nenhuma resposta recebida';
    } catch (e) {
      rethrow;
    }
  }

  /// Simula captura de screenshot (placeholder)
  /// Em produção, use um plugin nativo como screen_capturer
  Future<Uint8List?> captureScreen() async {
    // TODO: Implementar captura real usando screen_capturer ou similar
    // Por enquanto, retorna null para indicar que não está implementado
    return null;
  }
}
