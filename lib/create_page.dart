import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePage extends StatelessWidget {
  CreatePage({
    super.key,
    required this.onClose,
    required this.onDone
  });

  final void Function() onClose;
  final void Function() onDone;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'data',
          ),
          controller: controller,
          onSubmitted: (_) => _onDone(),
        ),
      ),
      appBar: AppBar(
        title: const Text('Создание раскладки'),
        leading: IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
        actions: [
          IconButton(onPressed: () => _onDone(), icon: const Icon(Icons.done))
        ],
      ),
    );
  }

  void _onDone() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String? savedData = prefs.getString('saved_data');
      prefs.setString('saved_data', jsonEncode((savedData != null ? jsonDecode(savedData) : []) + [controller.text]));
      onDone();
    });
  }
}