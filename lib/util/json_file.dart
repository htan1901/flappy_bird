import 'dart:convert';
import 'dart:io';
import 'package:flappy_bird/util/score.dart';
import 'package:path_provider/path_provider.dart';

class JsonManager {
  static JsonManager? _instance;

  JsonManager._internal() {
    _instance = this;
  }

  factory JsonManager() => _instance ?? JsonManager._internal();

  Future<String> get _directoryPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async {
    final String path = await _directoryPath;
    File file = File('$path/data/score.json');
    if (await file.exists()) return file;
    return file.create(recursive: true);
  }

  Future<Map<String, dynamic>?> readJsonFile() async {
    try {
      File file = await _file;
      String fileContent = file.readAsStringSync();
      if (fileContent.isEmpty) return null;
      print('read: ${json.decode(fileContent)}');
      return json.decode(fileContent);
    } catch (exception) {
      print(exception);
      return null;
    }
  }

  writeJsonFile(Score score) async {
    File file = await _file;
    print('write: ${json.encode(score.toJson())}');
    await file.writeAsString(json.encode(score.toJson()).toString());
  }
}
