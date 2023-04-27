import 'package:flutter/material.dart';
import 'package:toureat/create_dialog_steps/general.dart';

class CreateDialog extends StatefulWidget {
  const CreateDialog({super.key, required this.onClose, required this.onDone});

  final void Function() onClose;
  final void Function() onDone;

  @override
  State<CreateDialog> createState() => _CreateDialogState();
}

class _CreateDialogState extends State<CreateDialog> {
  final controller = TextEditingController();

  int _step = 0;
  final List<Step> _steps = [
    const Step(title: Text('О походе'), content: CreateGeneral()),
    Step(title: const Text('...1'), content: Container()),
    Step(title: const Text('...2'), content: Container()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stepper(
            controlsBuilder:
                (BuildContext context, ControlsDetails controlsDetails) {
              Function()? onStepContinue = controlsDetails.onStepContinue;
              Function()? onStepCancel = controlsDetails.onStepCancel;
              if (_step == 0) {
                onStepCancel = null;
              }
              if (_step == _steps.length-1) {
                onStepContinue = null;
              }
                return Padding(
                  padding: const EdgeInsets.only(left: 8, top: 24, right: 8, bottom: 8),
                  child: Row(
                    children: <Widget>[
                      (onStepContinue != null) ? OutlinedButton(
                        onPressed: onStepContinue,
                        child: const Text('Дальше'),
                      ) : Container(),
                      const SizedBox(width: 8),
                      (onStepCancel != null) ? OutlinedButton(
                        onPressed: onStepCancel,
                        child: const Text('Назад'),
                      ) : Container(),
                    ],
                  ),
                );
            },
            currentStep: _step,
            type: StepperType.vertical,
            elevation: 0,
            steps: _steps,
            onStepCancel: () {
              if (_step > 0) {
                setState(() {
                  _step--;
                });
              }
            },
            onStepContinue: () {
              setState(() => _step++);
            },
            onStepTapped: (int index) => setState(() => _step = index),
          ),
      ),
      appBar: AppBar(
        title: const Text('Создание раскладки'),
        leading: IconButton(
            onPressed: widget.onClose, icon: const Icon(Icons.close)),
        actions: const [IconButton(onPressed: null, icon: Icon(Icons.done))],
      ),
    );
  }
}
