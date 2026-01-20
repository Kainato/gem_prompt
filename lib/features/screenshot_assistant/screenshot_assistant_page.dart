import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prompt_app/services/screenshot_service.dart';
import 'package:prompt_app/widgets/layout/wd_scaffold.dart';

class ScreenshotAssistantPage extends StatefulWidget {
  const ScreenshotAssistantPage({super.key});

  @override
  State<ScreenshotAssistantPage> createState() =>
      _ScreenshotAssistantPageState();
}

class _ScreenshotAssistantPageState extends State<ScreenshotAssistantPage> {
  String? _answer;
  bool _isLoading = false;
  bool _isPopupVisible = false;
  final ScrollController _scrollController = ScrollController();
  final ScreenshotService _service = ScreenshotService();

  @override
  void initState() {
    super.initState();
    _setupHotkeys();
  }

  void _setupHotkeys() {
    // Nota: Para hotkeys globais no desktop, você pode usar:
    // - hotkey_manager (requer configuração nativa)
    // - tray_manager com menu de contexto
    // Por enquanto, usamos botões na UI
  }

  Future<void> _captureAndAnalyze() async {
    setState(() {
      _isLoading = true;
      _answer = null;
    });

    try {
      // Tentar capturar screenshot
      final imageBytes = await _service.captureScreen();

      String answer;
      if (imageBytes != null) {
        // Analisar imagem capturada
        answer = await _service.analyzeScreenshot(imageBytes);
      } else {
        // Fallback: usar texto de exemplo
        answer = await _service.analyzeText(
          'Exemplo de análise. Configure a captura de tela nativa para uso completo.',
        );
      }

      setState(() {
        _answer = answer;
        _isPopupVisible = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _answer = '❌ Erro: ${e.toString()}';
        _isPopupVisible = true;
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    if (_answer != null) {
      Clipboard.setData(ClipboardData(text: _answer!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Copiado para a área de transferência'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _closePopup() {
    setState(() {
      _isPopupVisible = false;
      _answer = null;
    });
  }

  void _toggleVisibility() {
    setState(() {
      _isPopupVisible = !_isPopupVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WdScaffold(
      title: 'Screenshot Assistant',
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⚡ Assistente de Screenshot com Gemini 2.0',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Instruções:'),
                      const SizedBox(height: 8),
                      _buildInstruction(
                        '📸 Clique em "Capturar & Analisar" para processar',
                      ),
                      _buildInstruction(
                        '📋 Use "Copiar" para copiar a resposta',
                      ),
                      _buildInstruction(
                        '👁️ Use "Mostrar/Ocultar" para alternar visibilidade',
                      ),
                      _buildInstruction('❌ Use "Fechar" para fechar o popup'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _captureAndAnalyze,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.screenshot),
                    label: Text(
                      _isLoading ? 'Processando...' : 'Capturar & Analisar',
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_answer != null) ...[
                    ElevatedButton.icon(
                      onPressed: _copyToClipboard,
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copiar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _toggleVisibility,
                      icon: Icon(
                        _isPopupVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 18,
                      ),
                      label: Text(_isPopupVisible ? 'Ocultar' : 'Mostrar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _closePopup,
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Fechar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          // Popup flutuante
          if (_answer != null && _isPopupVisible)
            Positioned(left: 20, bottom: 40, child: _buildFloatingPopup()),
        ],
      ),
    );
  }

  Widget _buildInstruction(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Text('• $text'),
    );
  }

  Widget _buildFloatingPopup() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      color: const Color(0xFF1e1e1e),
      child: Container(
        width: 320,
        constraints: const BoxConstraints(maxHeight: 400),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 350),
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: SelectableText(
                    _answer ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Courier',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy, size: 14),
                label: const Text('📋 Copiar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF333333),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  textStyle: const TextStyle(fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
