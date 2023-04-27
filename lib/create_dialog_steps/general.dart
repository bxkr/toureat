import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateGeneral extends StatefulWidget {
  const CreateGeneral({super.key});

  @override
  State<CreateGeneral> createState() => _CreateGeneralState();
}

class _CreateGeneralState extends State<CreateGeneral> {
  bool _hikeIsNotValidated = false;
  String? _currentHikeText;
  final GlobalKey _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Form(
            key: _formKey,
            child: Container(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 512,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _createDigitsField('Участников похода',
                            suffixText: 'человек'),
                        const SizedBox(width: 16),
                        _createDigitsField('Длительность похода',
                            suffixText: 'дней'),
                      ],
                    ),
                    Row(
                      children: [
                        _createAutocompleteField('Тип похода'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Flexible _createDigitsField(String label, {String suffixText = ''}) {
    return Flexible(
      child: TextFormField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
            counter: Container(),
            suffixText: suffixText),
        maxLength: 2,
        keyboardType: const TextInputType.numberWithOptions(),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }

  Flexible _createAutocompleteField(String label) {
    return Flexible(
      child: Autocomplete<Hike>(
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          focusNode.addListener(() {
            if (!focusNode.hasFocus) {
              if (!Hike.values.map((e) => e.name).contains(textEditingController.text)) {
                setState(() {
                  textEditingController.text = '';
                });
              }
            }
          });
          return TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: label,
              errorText: (() {
                if (_hikeIsNotValidated) {
                  return 'Выберите из списка';
                }
              })(),
            ),
            controller: textEditingController,
            focusNode: focusNode,
            onFieldSubmitted: (String value) => onFieldSubmitted(),
          );
        },
        displayStringForOption: (Hike hike) => hike.name,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return Hike.values;
          }
          return Hike.values.where((Hike option) {
            return option.name
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        initialValue: TextEditingValue(text: (_currentHikeText) ?? ''),
        onSelected: (Hike selection) {
          _currentHikeText = selection.name;
          setState(() {
            _hikeIsNotValidated = false;
          });
        },
      ),
    );
  }
}

enum Hike {
  water('Водный'),
  onFoot('Пеший'),
  onSki('Лыжный');

  const Hike(this.name);

  final String name;
}
