import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../enum/pages_enum.dart';
import '../../widgets/form/wd_text_form_field.dart';
import '../../widgets/layout/wd_scaffold.dart';
import 'task_creator_controller.dart';

class TaskCreatorPage extends StatefulWidget {
  const TaskCreatorPage({super.key});

  @override
  TaskCreatorPageState createState() => TaskCreatorPageState();
}

class TaskCreatorPageState extends State<TaskCreatorPage> {
  final TaskCreatorController controller = TaskCreatorController();

  @override
  Widget build(BuildContext context) {
    return WdScaffold(
      title: PagesEnum.task.title,
      actions: [
        IconButton(
          icon: Icon(Icons.copy),
          onPressed: () => controller.copyToClipboard(context),
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () => controller.limparInput(),
        ),
      ],
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            spacing: 16.0,
            children: [
              WdTextFormField(
                label: "Atividade",
                hintText: "Descreva como é a sua atividade que você deseja reformular",
                controller: controller.inputController,
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.gerarPromptEChamarIA();
                  }
                },
                child: Text("Consultar IA"),
              ),
              ValueListenableBuilder(
                valueListenable: controller.loadingInput,
                builder: (BuildContext context, bool loading, Widget? child) {
                  if (loading) {
                    return CircularProgressIndicator();
                  } else {
                    return ValueListenableBuilder(
                      valueListenable: controller.respostaIA,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                            if (value.isEmpty) {
                              return SizedBox.shrink();
                            } else {
                              return Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text("Resposta da IA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                                      trailing: IconButton(
                                        icon: Icon(Icons.copy),
                                        onPressed: () => controller.copyToClipboard(context, copiarResposta: true),
                                      ),
                                    ),
                                    Markdown(
                                      data: value,
                                      selectable: true,
                                      shrinkWrap: true,
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
