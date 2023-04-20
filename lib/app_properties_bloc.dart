import 'dart:async';

final appBloc = AppPropertiesBloc();

class AppPropertiesBloc{
  final StreamController<String> _title = StreamController<String>();

  Stream<String> get titleStream => _title.stream;

  updateTitle(String newTitle){
    _title.sink.add(newTitle);
  }

  dispose() {
    _title.close();
  }
}