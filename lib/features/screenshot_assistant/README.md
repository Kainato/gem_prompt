# Screenshot Assistant - Flutter

Esta é uma implementação em Flutter do código Python fornecido que usa a API do Google Gemini para analisar screenshots e responder perguntas.

## Funcionalidades

- 📸 **Captura de Screenshot**: Captura a tela atual (requer configuração nativa)
- 🤖 **Análise com Gemini 2.0**: Usa o modelo Gemini 2.0 Flash para analisar imagens
- 📋 **Cópia Rápida**: Botão para copiar respostas para a área de transferência
- 👁️ **Controle de Visibilidade**: Ocultar/mostrar popup de respostas
- 🎨 **Interface Moderna**: UI similar ao código Python original

## Equivalência com o Código Python

### Python (Original)
- **Hotkeys**: 
  - `Alt+Shift+S`: Capturar e analisar
  - `Alt+Shift+D`: Fechar popup
  - `Alt+Shift+H`: Ocultar/mostrar popup
- **Bibliotecas**: `keyboard`, `google-generativeai`, `tkinter`, `PIL`

### Flutter (Nova Implementação)
- **UI Buttons**: Botões na interface (hotkeys globais requerem configuração nativa)
- **Packages**: `google_generative_ai`, `screenshot`, `clipboard`
- **Plataforma**: Suporte para Desktop (macOS, Windows, Linux), Web e Mobile

## Configuração

### 1. Instalar Dependências

```bash
flutter pub get
```

### 2. Configurar API Key do Gemini

Execute o app com a API key:

```bash
flutter run --dart-define=API_KEY=sua_chave_api_aqui
```

Ou adicione ao arquivo de configuração de lançamento (`.vscode/launch.json`):

```json
{
  "configurations": [
    {
      "name": "Flutter with API Key",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=API_KEY=AIzaSyC..."
      ]
    }
  ]
}
```

### 3. Captura de Screenshot (Opcional)

Para captura real de screenshots no desktop, adicione ao `pubspec.yaml`:

```yaml
dependencies:
  screen_capturer: ^0.2.1  # Para macOS/Windows/Linux
```

E atualize o método `captureScreen()` em `lib/services/screenshot_service.dart`:

```dart
import 'package:screen_capturer/screen_capturer.dart';

Future<Uint8List?> captureScreen() async {
  final capturedData = await ScreenCapturer.instance.capture();
  if (capturedData != null) {
    final file = File(capturedData.imagePath);
    return await file.readAsBytes();
  }
  return null;
}
```

## Uso

1. **Navegar para Screenshot Assistant**: Use o menu lateral para acessar "Screenshot Assistant"

2. **Capturar e Analisar**: 
   - Clique no botão "Capturar & Analisar"
   - O sistema processará e exibirá a resposta

3. **Copiar Resposta**: Clique em "Copiar" para copiar a resposta

4. **Controlar Popup**: Use "Mostrar/Ocultar" para alternar visibilidade

5. **Fechar**: Clique em "Fechar" para remover o popup

## Estrutura do Código

```
lib/
├── features/
│   └── screenshot_assistant/
│       └── screenshot_assistant_page.dart  # UI principal
├── services/
│   └── screenshot_service.dart             # Lógica de captura e análise
└── enum/
    └── pages_enum.dart                     # Configuração de rotas
```

## Diferenças do Python Original

1. **Hotkeys Globais**: No Flutter desktop, hotkeys globais requerem configuração nativa adicional. Por enquanto, a implementação usa botões na UI.

2. **Captura de Tela**: A captura nativa requer plugins específicos para cada plataforma. A implementação base usa placeholders.

3. **Popup Flutuante**: Implementado como widget posicionado, similar ao Tkinter `overrideredirect`.

## Próximos Passos

- [ ] Implementar hotkeys globais usando `hotkey_manager`
- [ ] Adicionar captura de tela nativa com `screen_capturer`
- [ ] Implementar OCR com EasyOCR (equivalente ao `gemini_coding2.py`)
- [ ] Adicionar configurações de tempo de auto-fechamento
- [ ] Suporte para múltiplos idiomas

## Modelos Gemini Disponíveis

- `gemini-2.0-flash-exp` (padrão - mais rápido)
- `gemini-1.5-pro` (mais preciso)
- `gemini-1.5-flash` (balanceado)

## Licença

Este projeto é uma reimplementação em Flutter do código Python fornecido.
