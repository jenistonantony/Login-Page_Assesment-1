/// A simple in-memory cache manager to store/retrieve data that doesn't
/// necessarily require persistence.
///
/// Optionally, you can integrate SharedPreferences or Hive for disk-based caching.
class CacheManager {
  /// Holds cached items in-memory.
  static final Map<String, dynamic> _cache = {};

  /// Adds or updates an item in the cache.
  ///
  /// [key] is a unique identifier for the cached data.
  /// [value] is the data to store.
  static void setItem(String key, dynamic value) {
    _cache[key] = value;
  }

  /// Retrieves an item from the cache by [key].
  ///
  /// Returns `null` if the key is not found.
  static T? getItem<T>(String key) {
    final data = _cache[key];
    if (data is T) {
      return data;
    }
    return null;
  }

  /// Removes an item from the cache.
  ///
  /// [key] identifies the data to be removed.
  static void removeItem(String key) {
    _cache.remove(key);
  }

  /// Clears all items from the in-memory cache.
  static void clearCache() {
    _cache.clear();
  }
}
