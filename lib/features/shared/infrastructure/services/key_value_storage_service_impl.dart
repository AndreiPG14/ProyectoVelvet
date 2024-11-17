import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvet/features/shared/infrastructure/services/key_value_storage_service.dart';

class KeyValueStorageServiceImpl implements KeyValueStorageService {
  Future<SharedPreferences> _getInstance() async =>
      await SharedPreferences.getInstance();

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await _getInstance();
    switch (T) {
      case String:
        return prefs.getString(key) as T?;
      case int:
        return prefs.getInt(key) as T?;
      case double:
        return prefs.getDouble(key) as T?;
      case bool:
        return prefs.getBool(key) as T?;
      case Map:
        return prefs.getString(key) as T?;
      case List:
        return prefs.getString(key) as T?;
      default:
        throw Exception('Type not supported');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await _getInstance();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await _getInstance();
    switch (T) {
      case String:
        await prefs.setString(key, value as String);
        break;
      case int:
        await prefs.setInt(key, value as int);
        break;
      case double:
        await prefs.setDouble(key, value as double);
        break;
      case bool:
        await prefs.setBool(key, value as bool);
        break;
      case Map:
        await prefs.setString(key, value as String);
        break;
      case List:
        await prefs.setString(key, value as String);
        break;
      default:
        throw Exception('Type not supported');
    }
  }
}
