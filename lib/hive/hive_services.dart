import 'package:hive/hive.dart';

class HiveServices {
  static String boxName = "creativeAdvanceTech";
  static String favoriteList = "favoriteList";
  static var creativeAdvanceHiveBox;

  static openBox(String boxName) async {
    creativeAdvanceHiveBox = await Hive.openBox(boxName);
  }

  static insertString(String key, String value) async {
    deleteString(key);
    creativeAdvanceHiveBox.put(key, value);
  }

  static Future<String?> getString(String key) async {
    return creativeAdvanceHiveBox.get(key);
  }

  static deleteString(String key) async {
    creativeAdvanceHiveBox.delete(key);
  }
}
