// clase abstracta para el servicio de almacenamiento de claves, shared_preferences
abstract class KeyValueStorageService {
  Future<void> setKeyValue<T>(String key, T value);
  Future<T?> getValue<T>(String key); // siempre será opcional
  Future<bool> removeKey(String key);
}