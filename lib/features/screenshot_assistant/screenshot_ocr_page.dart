import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prompt_app/services/screenshot_service.dart';
import 'package:prompt_app/widgets/layout/wd_scaffold.dart';

/// Página com OCR - equivalente ao gemini_coding2.py
/// Usa OCR para extrair texto antes de enviar ao Gemini
class ScreenshotOcrPage extends StatefulWidget {
  const ScreenshotOcrPage({super.key});

  @override
  State<ScreenshotOcrPage> createState() => _ScreenshotOcrPageState();
}

class _ScreenshotOcrPageState extends State<ScreenshotOcrPage> {
  String? _extractedText;
  String? _answer;
  bool _isLoading = false;
  bool _isPopupVisible = false;
  final ScrollController _scrollController = ScrollController();
  final ScreenshotService _service = ScreenshotService();

  Future<void> _captureAndExtract() async {
    setState(() {
      _isLoading = true;
      _extractedText = null;
      _answer = null;
    });

    try {
      // TODO: Implementar OCR real usando google_ml_kit ou similar
      // Por enquanto, simulamos com texto de exemplo
      await Future.delayed(const Duration(seconds: 1));

      final extractedText = '''
Exemplo de texto extraído via OCR:

1. Qual é a complexidade de tempo do algoritmo de busca binária?
2. Como implementar uma árvore binária em Python?
3. Explique o conceito de closures em JavaScript.
''';

      setState(() {
        _extractedText = extractedText;
      });

      if (extractedText.trim().isEmpty) {
        throw Exception('Nenhum texto detectado no screenshot');
      }

      // Enviar para Gemini
      final answer = await _service.analyzeText(extractedText);

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return WdScaffold(
      title: 'Screenshot + OCR',
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
                        '🚀 Gemini 2.0 Flash + OCR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Equivalente ao gemini_coding2.py',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Funcionalidades:'),
                      const SizedBox(height: 8),
                      _buildFeature('📸 Captura de screenshot'),
                      _buildFeature('🔤 Extração de texto via OCR'),
                      _buildFeature('🤖 Análise com Gemini 2.0'),
                      _buildFeature('📋 Popup com timer de 4s (auto-close)'),
                      _buildFeature('📝 Botão de cópia incluído'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _captureAndExtract,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.camera_alt),
                label: Text(
                  _isLoading
                      ? 'Processando OCR...'
                      : 'Capturar & Extrair (OCR)',
                ),
              ),
              if (_extractedText != null) ...[
                const SizedBox(height: 16),
                Card(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Texto Extraído (OCR):',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _extractedText!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          // Popup flutuante com auto-close
          if (_answer != null && _isPopupVisible)
            Positioned(left: 20, bottom: 60, child: _buildAutoClosePopup()),
        ],
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Text('• $text', style: const TextStyle(fontSize: 13)),
    );
  }

  Widget _buildAutoClosePopup() {
    // Auto-close após 4 segundos
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _isPopupVisible) {
        _closePopup();
      }
    });

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      color: const Color(0xFF1e1e1e),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 270),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header com timer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Resposta (fecha em 4s)',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    color: Colors.white70,
                    onPressed: _closePopup,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 4),
            // Conteúdo
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(6),
                  child: SelectableText(
                    _answer ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Courier',
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Botão copiar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy, size: 14),
                label: const Text('📋 Copy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF333333),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  textStyle: const TextStyle(fontSize: 9),
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
