enum GeminiModel {
  geminiPro,
  geminiFlash
}

extension GeminiModelExtension on GeminiModel {
  String get modelName {
    switch (this) {
      case GeminiModel.geminiPro:
        return 'gemini-pro';
      case GeminiModel.geminiFlash:
        return 'gemini-1.5-flash';
    }
  }
}