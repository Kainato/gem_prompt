import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WdHelpers {
  static void copyClipboard(
    BuildContext context, {
    required String text,
    required String message,
  }) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
