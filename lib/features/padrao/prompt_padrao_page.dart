import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:prompt_app/features/padrao/prompt_padrao_controller.dart';

import '../../enum/pages_enum.dart';
import '../../functions/wd_helpers.dart';
import '../../services/gemini_service.dart';
import '../../widgets/form/wd_text_form_field.dart';
import '../../widgets/layout/wd_scaffold.dart';

class PromptPadraoPage extends StatefulWidget {
  const PromptPadraoPage({super.key});

  @override
  PromptPadraoPageState createState() => PromptPadraoPageState();
}

class PromptPadraoPageState extends State<PromptPadraoPage> {
  final PromptPadraoController controller = PromptPadraoController();

  @override
  Widget build(BuildContext context) {
    return WdScaffold(
      title: PagesEnum.padrao.title,
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
                  child: SelectionArea(
                    child: Markdown(
                      data: respostaIA!,
                      selectable: true,
                      shrinkWrap: true,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
