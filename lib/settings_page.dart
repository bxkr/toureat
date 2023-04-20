import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<List<Setting>> settings = SharedPreferences.getInstance().then((prefs) => [
    Setting(
        'Подтверждать отмену создания', 'ask_for_cancel_creation', true, prefs),
  ]);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) => FutureBuilder(builder: (_, widget) => widget.data ?? Container(), future: createSetting(index),),
        itemCount: 1),
      );
  }

  Future<Widget> createSetting(int index) async {
    return InkWell(
      onTap: () async => changeValueOf(
          (await settings)[index].preferencesName,
          !(await settings)[index].state),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Text((await settings)[index].title, style: Theme.of(context).textTheme.titleMedium),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Switch(
                      value: (await settings)[index].state,
                      onChanged: (value) async =>
                          changeValueOf((await settings)[index].preferencesName, value)),
                ),
              ),
            ],
          )),
    );
  }

  void changeValueOf(String preferencesName, bool newState) {
    setState(() {
      settings
      .then((settings) => settings
          .firstWhere((element) => element.preferencesName == preferencesName)
          .state = newState);
    });
  }
}

class Setting {
  Setting(this.title, this.preferencesName, this.defaultState, this.prefs);

  String title;
  String preferencesName;
  bool defaultState;
  SharedPreferences prefs;
  bool get state => prefs.getBool(preferencesName) ?? defaultState;
  set state (bool value) => prefs.setBool(preferencesName, value);
}
