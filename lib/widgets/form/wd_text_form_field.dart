import 'package:flutter/material.dart';

class WdTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  const WdTextFormField({super.key, required this.label, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
