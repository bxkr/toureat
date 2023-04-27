import 'package:flutter/material.dart';
import 'package:toureat/create_dialog_steps/general.dart';

class CreateDialog extends StatelessWidget {
  CreateDialog({super.key, required this.onClose, required this.onDone});

  final void Function() onClose;
  final void Function() onDone;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stepper(
            type: StepperType.horizontal,
            elevation: 0,
            steps: const [
              Step(title: Text('О походе'), content: CreateGeneral())
            ],
          )),
      appBar: AppBar(
        title: const Text('Создание раскладки'),
        leading: IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.done))
        ],
      ),
    );
  }
}
