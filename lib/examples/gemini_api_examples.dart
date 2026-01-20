import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

/// Exemplo de uso direto da API Gemini
/// Equivalente aos scripts Python do cheat.txt
void main() async {
  // Configuração da API (equivalente ao config.py)
  const apiKey = 'AIzaSyC...'; // Substitua pela sua chave

  // Exemplo 1: Análise de texto simples
  await exemploTextoSimples(apiKey);

  // Exemplo 2: Análise de imagem
  // await exemploComImagem(apiKey);

  // Exemplo 3: Com streaming
  // await exemploComStreaming(apiKey);
}

/// Exemplo 1: Análise de texto (equivalente a pedir ajuda sem screenshot)
Future<void> exemploTextoSimples(String apiKey) async {
  print('🤖 Exemplo 1: Análise de Texto\n');

  // Configurar modelo
  final model = GenerativeModel(model: 'gemini-2.0-flash-exp', apiKey: apiKey);

  // Prompt similar ao usado no Python
  const prompt = '''
Você é um tutor AI especialista.
Explique brevemente o que é uma função recursiva em programação.
Mantenha a resposta curta e direta.
''';

  // Gerar resposta
  final response = await model.generateContent([Content.text(prompt)]);

  print('📝 Resposta:');
  print(response.text);
  print('\n${'=' * 50}\n');
}

/// Exemplo 2: Análise de imagem (equivalente aos scripts Python)
Future<void> exemploComImagem(String apiKey, Uint8List imageBytes) async {
  print('🖼️ Exemplo 2: Análise de Imagem\n');

  final model = GenerativeModel(model: 'gemini-2.0-flash-exp', apiKey: apiKey);

  // Prompt equivalente ao gemi.py
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

  print('📝 Resposta:');
  print(response.text);
  print('\n${'=' * 50}\n');
}

/// Exemplo 3: Com streaming (para respostas longas)
Future<void> exemploComStreaming(String apiKey) async {
  print('📡 Exemplo 3: Streaming\n');

  final model = GenerativeModel(model: 'gemini-2.0-flash-exp', apiKey: apiKey);

  const prompt = 'Explique o padrão de design Singleton com exemplo em Dart.';

  print('📝 Resposta (streaming):');

  // Stream de resposta
  final stream = model.generateContentStream([Content.text(prompt)]);

  await for (final chunk in stream) {
    if (chunk.text != null) {
      print(chunk.text);
    }
  }

  print('\n${'=' * 50}\n');
}

/// Função auxiliar: Equivalente à configuração do modelo
GenerativeModel configurarModelo(
  String apiKey, {
  String modelo = 'gemini-2.0-flash-exp',
}) {
  return GenerativeModel(
    model: modelo,
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.7,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 2048,
    ),
  );
}

/// Função auxiliar: Criar prompt para análise de código
String criarPromptParaCodigo(String linguagem) {
  return '''
Você é dado um screenshot que contém uma questão de programação.
Retorne APENAS o código correto em $linguagem.
NÃO adicione explicações.
NÃO adicione markdown.
Apenas o código puro.
''';
}

/// Função auxiliar: Criar prompt para questões teóricas
String criarPromptParaTeoria() {
  return '''
Você é um tutor AI especialista.
Analise a questão e forneça uma resposta direta e concisa.
- Se for teoria: explique de forma clara
- Se for múltipla escolha: indique a alternativa correta
- Se for raciocínio: mostre o resultado
Mantenha a resposta curta.
''';
}

/* 
COMPARAÇÃO COM PYTHON:

Python (gemi.py):
---
import google.generativeai as genai
genai.configure(api_key=API_KEY)
model = genai.GenerativeModel("gemini-2.5-flash")

response = model.generate_content([
    "Prompt aqui",
    {"mime_type": "image/png", "data": open("screenshot.png", "rb").read()}
])
answer = response.text.strip()
---

Dart/Flutter (equivalente):
---
import 'package:google_generative_ai/google_generative_ai.dart';

final model = GenerativeModel(
  model: 'gemini-2.0-flash-exp',
  apiKey: apiKey,
);

final response = await model.generateContent([
  Content.multi([
    TextPart('Prompt aqui'),
    DataPart('image/png', imageBytes),
  ]),
]);
final answer = response.text ?? '';
---

PRINCIPAIS DIFERENÇAS:
1. Python: síncrono | Dart: assíncrono (async/await)
2. Python: dict para imagem | Dart: DataPart
3. Python: .text.strip() | Dart: .text ?? ''
4. Python: keyboard para hotkeys | Flutter: hotkey_manager (requer setup)
5. Python: tkinter para UI | Flutter: Material Design widgets
*/
