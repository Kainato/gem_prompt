import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'gemini_service.dart';

const String apiKey = String.fromEnvironment('API_KEY');
void main() {
  runApp(PromptApp());
}

class PromptApp extends StatelessWidget {
  const PromptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de Prompts',
      theme: ThemeData(primarySwatch: Colors.indigo),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: PromptForm(),
    );
  }
}

class PromptForm extends StatefulWidget {
  const PromptForm({super.key});

  @override
  _PromptFormState createState() => _PromptFormState();
}

class _PromptFormState extends State<PromptForm> {
  final _formKey = GlobalKey<FormState>();
  final _papelController = TextEditingController();
  final _contextoController = TextEditingController();
  final _objetivoController = TextEditingController();
  final _detalhesController = TextEditingController();
  final _formatoController = TextEditingController();
  final _tomController = TextEditingController();
  final _exemploController = TextEditingController();
  ValueNotifier<bool> errorPrompt = GeminiService.errorPrompt;
  String prompt = "";

  String? respostaIA;
  bool carregando = false;

  final gemini = GeminiService();

  Future<void> gerarPromptEChamarIA() async {
    log("Modelo selecionado: ${GeminiService.selectedModel.$2.value}");
    List<String?> partes = [
      _papelController.text.isNotEmpty
          ? "Atue como: ${_papelController.text}"
          : null,
      _contextoController.text.isNotEmpty
          ? "Contexto: ${_contextoController.text}"
          : null,
      _objetivoController.text.isNotEmpty
          ? "Objetivo: ${_objetivoController.text}"
          : null,
      _detalhesController.text.isNotEmpty
          ? "Detalhes/Regras: ${_detalhesController.text}"
          : null,
      _formatoController.text.isNotEmpty
          ? "Formato: ${_formatoController.text}"
          : null,
      _tomController.text.isNotEmpty
          ? "Tom/Estilo: ${_tomController.text}"
          : null,
      _exemploController.text.isNotEmpty
          ? "Exemplo/Referência: ${_exemploController.text}"
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gerador de Prompts IA"),
        centerTitle: true,
        actions: [
          ValueListenableBuilder(
            valueListenable: errorPrompt,
            builder: (context, value, child) {
              if (value) {
                return IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    if (respostaIA != null) {
                      Clipboard.setData(ClipboardData(text: prompt));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Prompt copiado para a área de transferência!",
                          ),
                        ),
                      );
                    }
                  },
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                respostaIA = null;
                carregando = false;
                _papelController.clear();
                _contextoController.clear();
                _objetivoController.clear();
                _detalhesController.clear();
                _formatoController.clear();
                _tomController.clear();
                _exemploController.clear();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FutureBuilder(
                    future: GeminiService.listarModelos(apiKey),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LinearProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Erro ao carregar modelos");
                      } else {
                        return DropdownMenu(
                          menuHeight: MediaQuery.of(context).size.height * 0.4,
                          dropdownMenuEntries: GeminiService.dropdownModelos,
                          expandedInsets: EdgeInsets.all(0),
                          enableSearch: false,
                          enableFilter: false,
                          label: Text("Selecione o modelo de IA"),
                          controller: GeminiService.selectedModel.$1,
                          onSelected: (value) {
                            if (value != null) {
                              GeminiService.selectedModel.$2.value = value;
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
                buildTextField("Papel/Especialista", _papelController),
                buildTextField("Contexto", _contextoController),
                buildTextField("Objetivo", _objetivoController),
                buildTextField("Detalhes/Regras", _detalhesController),
                buildTextField("Formato da resposta", _formatoController),
                buildTextField("Tom/Estilo", _tomController),
                buildTextField("Exemplo/Referência", _exemploController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      gerarPromptEChamarIA();
                    }
                  },
                  child: Text("Gerar Prompt e Consultar IA"),
                ),
                SizedBox(height: 20),
                if (carregando) CircularProgressIndicator(),
                if (respostaIA != null)
                  Card(
                    child: Markdown(
                      data: respostaIA!,
                      selectable: true,
                      shrinkWrap: true,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        maxLines: null,
      ),
    );
  }
}
