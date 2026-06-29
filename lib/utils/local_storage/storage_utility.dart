import 'package:get_storage/get_storage.dart';

class HkLocalStorage {
  final GetStorage _storage = GetStorage();

  static HkLocalStorage? _instance;
  HkLocalStorage._internal();

  factory HkLocalStorage.instance() {
    _instance ??= HkLocalStorage._internal();
    return _instance!;
  }

  static Future<void> init(String bucketName) async {
    await GetStorage.init(bucketName);
    _instance = HkLocalStorage._internal();
  }

  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Generic method to remove data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Clear all data in storage
  Future<void> clearAll() async {
    await _storage.erase();
  }
}