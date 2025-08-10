import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_storage_service.dart';

class KeyValueStorageServiceImp implements KeyValueStorageService {
  
  Future<SharedPreferencesWithCache> getSharedPref() async{
    return  SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions());

  }

  @override
  Future<T?> getValue<T>(String key) async{
    final pref = await getSharedPref();

   switch (T) {
    case const (int):
      return pref.getInt(key) as T?;
    case const (double):
      return pref.getDouble(key) as T?;
    case const (String):
      return pref.getString(key) as T?;
    case const (bool):
      return pref.getBool(key) as T?;
    case const(List<String>):
      return pref.getStringList(key) as T?;
    default:
      throw Exception('Tipo no soportado: $T');
  }
  }

  @override
  Future<bool> removeKey(String key) async{
    final pref = await getSharedPref();
    await pref.remove(key);
    return true;
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final pref = await getSharedPref();

    if (value is int) {
      pref.setInt(key, value);
      return;
    } 
    if (value is double) {
      pref.setDouble(key, value);
      return;
    } 
    if (value is String) {
      pref.setString(key, value);
      return;
    } 
    if (value is bool) {
      pref.setBool(key, value);
      return;
    } 
    if (value is List<String>) {
      pref.setStringList(key, value);
      return;
    } 
    
    throw Exception('Tipo no soportado');
   
  }
}