import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:prompt_app/main.dart';

import '../../enum/pages_enum.dart';
import '../../functions/wd_helpers.dart';
import '../../services/gemini_service.dart';
import '../../widgets/form/wd_text_form_field.dart';
import '../../widgets/layout/wd_scaffold.dart';

class PromptForm extends StatefulWidget {
  const PromptForm({super.key});

  @override
  PromptFormState createState() => PromptFormState();
}

class PromptFormState extends State<PromptForm> {
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
    return WdScaffold(
      title: PagesEnum.home.title,
      actions: [
        ValueListenableBuilder(
          valueListenable: errorPrompt,
          builder: (context, value, child) {
            if (value) {
              return IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  if (respostaIA != null) {
                    WdHelpers.copyClipboard(
                      context,
                      text: prompt,
                      message: "Prompt copiado para a área de transferência!",
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16.0,
            children: [
              FutureBuilder(
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
              WdTextFormField(
                label: "Papel/Especialista",
                controller: _papelController,
              ),
              WdTextFormField(
                label: "Contexto",
                controller: _contextoController,
              ),
              WdTextFormField(
                label: "Objetivo",
                controller: _objetivoController,
              ),
              WdTextFormField(
                label: "Detalhes/Regras",
                controller: _detalhesController,
              ),
              WdTextFormField(
                label: "Formato da resposta",
                controller: _formatoController,
              ),
              WdTextFormField(label: "Tom/Estilo", controller: _tomController),
              WdTextFormField(
                label: "Exemplo/Referência",
                controller: _exemploController,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    gerarPromptEChamarIA();
                  }
                },
                child: Text("Gerar Prompt e Consultar IA"),
              ),
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
    );
  }
}
