import 'package:shared_preferences/shared_preferences.dart';
class sherd{
  /// string
  static Future<void>saveString(String key, String value)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
  static Future<String?> getString(String key)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.getString(key);
  }
  static Future<void>removeString(String key)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
  ///BooL
  static Future<void>saveBoolian(String key, bool value)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key , value);
  }
  static Future<bool?>getBoolian(String key)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.get(key);
  }
  static Future<void>removeBoolian(String key)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
  ///int
  static Future<void>saveInt(String key, int value)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
  static Future<int?>getInt(String key)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.get(key);
  }
  static Future<void>removeInt(String key)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
  ///sit double
  static Future<void>sitDouble(String key, value)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }
  static Future<double?>getDouble(String key)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.getDouble(key);
  }
  static Future<void>removeDouble(String key)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
  ///listofstring
  static Future<void>sitOfstring(String key, value)async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }
  static Future<List<String>?>getListOfstring(String key)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.getStringList(key);
  }
  static Future<void>removeListOfstring(String key)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}