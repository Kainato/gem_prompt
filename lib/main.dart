import 'package:flutter/material.dart';

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

  String? respostaIA;
  bool carregando = false;

  final gemini = GeminiService(apiKey);

  Future<void> gerarPromptEChamarIA() async {
    final prompt =
        """
    Atue como ${_papelController.text}.
    Contexto: ${_contextoController.text}
    Objetivo: ${_objetivoController.text}
    Detalhes/Regras: ${_detalhesController.text}
    Formato: ${_formatoController.text}
    Tom/Estilo: ${_tomController.text}
    Exemplo/Referência: ${_exemploController.text}
    """;

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
      appBar: AppBar(title: Text("Gerador de Prompts IA")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                  SelectableText(respostaIA!, style: TextStyle(fontSize: 16)),
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
