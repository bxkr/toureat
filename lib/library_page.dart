import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<StatefulWidget> createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<SharedPreferences>(
          future: prefs,
          builder:
              (BuildContext context,
              AsyncSnapshot<SharedPreferences> snapshot) {
            SharedPreferences? data = snapshot.data;
            String? savedData = data?.getString('saved_data');
            List<dynamic> optionList =
            (savedData == null) ? [] : (jsonDecode(savedData));
            if (optionList.isNotEmpty) {
              return ListView.builder(
                  itemCount: optionList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: LimitedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Wrap(crossAxisAlignment: WrapCrossAlignment.center,children: [
                            Text(optionList[index]),
                            IconButton(onPressed: () {
                              setState(() {
                                optionList.removeAt(index);
                                data?.setString(
                                    'saved_data', jsonEncode(optionList));
                              });
                            }, icon: const Icon(Icons.delete))
                          ],),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text('Пока нет сохраненных раскладок'),
              );
            }
          },
        ));
  }
}
