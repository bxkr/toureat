import 'package:flutter/material.dart';
import 'package:toureat/create_page.dart';
import 'package:toureat/library_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Раскладка',
      theme: ThemeData(
          useMaterial3: true),
      home: const MyHomePage(title: 'Раскладка'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  Widget _currentPage = const LibraryPage();
  final List<NavigationRailDestination> _destinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.library_books_outlined),
      selectedIcon: Icon(Icons.library_books),
      label: Text('Библиотека'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.cloud_done_outlined),
      selectedIcon: Icon(Icons.cloud_done),
      label: Text('Примеры'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: Text('Настройки'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: Row(
            children: <Widget>[
              NavigationRail(
                destinations: _destinations,
                selectedIndex: _selectedIndex,
                leading: FloatingActionButton(
                  elevation: 0,
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext mainDialogContext) =>
                        Dialog.fullscreen(
                            child: CreatePage(
                      onClose: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Вы уверены?'),
                                  content: const Text(
                                      'Эти изменения не будут сохранены'),
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(mainDialogContext);
                                        },
                                        child: const Text('Да, удалить'))
                                  ],
                                ));
                      },
                      onDone: () {
                        setState(() {
                          Navigator.pop(mainDialogContext);
                          onDestinationChanged(_selectedIndex);
                        });
                      },
                    )),
                  ),
                  child: const Icon(Icons.add),
                ),
                onDestinationSelected: (int index) {
                  setState(() {
                    onDestinationChanged(index);
                  });
                },
              ),
              const VerticalDivider(),
              _currentPage
            ],
          ),
        ));
  }

  void onDestinationChanged(int index) {
    _selectedIndex = index;
    switch (index) {
      case 0:
        // ignore: prefer_const_constructors
        _currentPage = LibraryPage();
        break;
      default:
        _currentPage = Container();
    }
  }
}
