enum GeminiModelEnum {
  geminiPro,
  geminiFlash
}

extension GeminiModelExtension on GeminiModelEnum {
  String get modelName {
    switch (this) {
      case GeminiModelEnum.geminiPro:
        return 'gemini-pro';
      case GeminiModelEnum.geminiFlash:
        return 'gemini-1.5-flash';
    }
  }
}