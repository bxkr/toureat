import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateGeneral extends StatelessWidget {
  const CreateGeneral({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: GlobalKey(),
          child: Container(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 512,
              child: Row(
                children: [
                  _createDigitsField('Участников похода', suffixText: 'человек'),
                  const SizedBox(width: 16),
                  _createDigitsField('Длительность похода', suffixText: 'дней'),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Flexible _createDigitsField(String label, {String suffixText = ''}) {
    return Flexible(
      child: TextFormField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          counter: Container(),
          suffixText: suffixText
        ),
        maxLength: 2,
        keyboardType: const TextInputType.numberWithOptions(),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
