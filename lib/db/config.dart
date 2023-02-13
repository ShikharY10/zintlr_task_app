// ignore_for_file: avoid_print

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

DataBase getDataBase() {
  return GetIt.I.get<DataBase>(instanceName: "db");
}

class DataBase {

  // This is a box according to hive and it will primarily
  // be used specially for storing app settings.
  late Box<String> _settings;

  // This is a box accoring to hive and it will be used
  // specially for storing posts.
  late Box<String> _posts;

  // This function should be called before calling any 
  // other methods of this class. The recommendation is 
  // that this method should be called in entry-point "main()"
  // function. This method initializes Hive database and also
  // opens the hive boxes.
  initilizeHive(String path) async {
    await Hive.initFlutter(path);

    _settings = await Hive.openBox<String>("settings");
    _posts = await Hive.openBox("todos");
  }

  // Used for storing single key/value pair in the database.
  String? get(String boxName, String key) {
    switch (boxName) {
      case "settings":
        return _settings.get(key);
      case "posts":
        return _posts.get(key);
      default:
        return null;
    }
  }

  // Used for getting single key/value pair from the database.
  Future<void> set(String boxName, String key, String value) async {
    switch (boxName) {
      case "settings":
        await _settings.put(key, value);
        break;
      case "posts":
        await _posts.put(key, value);
        break;
      default:
        break;
    }
  }
  
  Map<String, String> _getAll(Box<String> box) {
    Map<String, String> data = {};
    List<String> values = box.values.toList();
    List<dynamic> keys = box.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      data[keys[i]] = values[i];
    }
    return data;
  }

  // Used for getting multiple key/value pairs at once.
  Map<String, String> getALL(String boxName) {
    switch (boxName) {
      case "settings":
        return _getAll(_settings);
      case "posts":
        return _getAll(_posts);
      default:
        return {};
    }
  }

  Future<void> _setAll(Box<String> box, Map<String, String> entries) async {
    await box.putAll(entries);
  }

  // Used for storing multiple key/values pairs at once.
  Future<void> setAll(String boxName, Map<String, String> pairs) async {
    switch (boxName) {
      case "settings":
        await _setAll(_settings, pairs);
        break;
      case "posts":
        await _setAll(_posts, pairs);
        break;
      default:
        break;
    }
  }

  // this function shows all the data present in the 
  // specified box in the form of Map.
  void showAll(String boxName) {
    switch (boxName) {
      case "settings":
        print(_settings.toMap());
        break;
      case "posts":
        print(_posts.toMap());
        break;
      default:
    }
  }

  // for clearing the intire box
  void clearBox(boxName) {
    switch (boxName) {
      case "settings":
        _settings.clear();
        break;
      case "posts":
        _posts.clear();
        break;
      default:
    }
  }

  // for deleting a specific key value pair
  void delete(String boxName, String key) {
    switch (boxName) {
      case "settings":
        _settings.delete(key);
        break;
      case "posts":
        _posts.delete(key);
        break;
      default:
    }
  }

  bool isKeyPresent(String boxName, String key) {
    switch (boxName) {
      case "settings":
        return _settings.containsKey(key);
      case "posts":
        return _posts.containsKey(key);
      default:
        return false;
    }
  }
} 