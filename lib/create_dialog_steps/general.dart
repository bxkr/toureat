import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateGeneral extends StatefulWidget {
  const CreateGeneral(this.approve, this.disapprove, {super.key});

  final void Function() approve;
  final void Function() disapprove;

  @override
  State<CreateGeneral> createState() =>
      // ignore: no_logic_in_create_state
      _CreateGeneralState(approve, disapprove);
}

class _CreateGeneralState extends State<CreateGeneral> {
  _CreateGeneralState(this.approve, this.disapprove);

  final void Function() approve;
  final void Function() disapprove;
  final _formKey = GlobalKey<FormState>();
  final List<GlobalKey<FormFieldState>> _formFieldKeys = [];

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
    final currentFormFieldKey = GlobalKey<FormFieldState>();
    _formFieldKeys.add(currentFormFieldKey);
    return Flexible(
      child: TextFormField(
        key: currentFormFieldKey,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Должно быть заполнено'; // it does not appear anywhere
          }
          return null;
        },
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
            counterText: ' ',
            suffixText: suffixText),
        maxLength: 2,
        keyboardType: const TextInputType.numberWithOptions(),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (String value) {
          validateAllAndApprove();
        },
      ),
    );
  }

  Flexible _createAutocompleteField(String label) {
    final currentFormFieldKey = GlobalKey<FormFieldState>();
    _formFieldKeys.add(currentFormFieldKey);
    TextEditingController? myTextEditingController;
    FocusNode? myFocusNode;
    return Flexible(
      child: Autocomplete<Hike>(
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          myTextEditingController = textEditingController;
          myFocusNode = focusNode;
          return TextFormField(
            key: currentFormFieldKey,
            validator: (String? value) {
              if (value == null ||
                  value.isEmpty ||
                  !Hike.values.map((e) => e.name).contains(value)) {
                return 'Должно быть заполнено'; // it does not appear anywhere
              }
              return null;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: label,
            ),
            controller: textEditingController,
            focusNode: focusNode,
            onFieldSubmitted: (String value) {
              validateAllAndApprove();
            },
            onChanged: (String value) {
              validateAllAndApprove();
            },
          );
        },
        displayStringForOption: (Hike hike) => hike.name,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '' ||
              Hike.values.map((e) => e.name).contains(textEditingValue.text)) {
            return Hike.values;
          }
          return Hike.values.where((Hike option) {
            return option.name
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        optionsViewBuilder: (
          BuildContext context,
          AutocompleteOnSelected<Hike> onSelected,
          Iterable<Hike> options,
        ) {
          return ListView.builder(
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    SizedBox(
                      width: 512,
                      child: Material(
                        elevation: 8,
                        child: ListTile(
                          title: Text(options.elementAt(index).name),
                          onTap: () {
                            myTextEditingController?.text =
                                options.elementAt(index).name;
                            validateAllAndApprove();
                            myFocusNode?.unfocus();
                          },
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }

  void validateAllAndApprove() {
    if (_formFieldKeys
        .map((e) => e.currentState != null
        ? e.currentState!.isValid
        : null)
        .where((element) =>
    element == null || element == false)
        .isEmpty) {
      approve();
    } else {
      disapprove();
    }
  }
}

enum Hike {
  water('Водный'),
  onFoot('Пеший'),
  onSki('Лыжный');

  const Hike(this.name);

  final String name;
}
