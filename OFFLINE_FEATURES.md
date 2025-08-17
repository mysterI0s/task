# Offline Features Documentation

## Overview

The Data Explorer app now includes comprehensive offline support, allowing users to access cached data even when the internet connection is unavailable or unstable.

## How It Works

### 1. Data Caching Strategy

The app implements an **offline-first approach** with the following strategy:

- **Automatic Caching**: All API responses are automatically cached to local storage
- **Cache Validation**: Cache expires after 1 hour (configurable in `AppConfig`)
- **Fallback Mechanism**: When API calls fail, the app falls back to cached data
- **Smart Refresh**: Users can manually refresh to get the latest data

### 2. Storage Implementation

The offline functionality uses **SharedPreferences** for local storage:

- **Products**: Cached as JSON strings for fast access
- **Recipes**: Cached as JSON strings with metadata
- **Categories**: Stored as string lists
- **Search History**: Maintains user search queries
- **Favorites**: Tracks user-favorited items
- **App State**: Persists user preferences and settings

### 3. Repository Layer Integration

Both `ProductRepositoryImpl` and `RecipeRepositoryImpl` have been enhanced:

```dart
// Example from ProductRepositoryImpl
Future<Either<Failure, ProductsResponse>> getProducts({...}) async {
  try {
    // 1. Try to get cached data first
    if (search == null && category == null && LocalStorageService.isCacheValid()) {
      final cachedProducts = LocalStorageService.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        // Apply pagination to cached data
        return Right(ProductsResponse(...));
      }
    }

    // 2. If no cached data, fetch from API
    final response = await _apiService.getProducts(...);
    
    // 3. Cache the response
    await LocalStorageService.cacheProducts(response.products);
    
    return Right(response);
  } on DioException catch (e) {
    // 4. If API fails, try cached data as fallback
    if (search == null && category == null) {
      final cachedProducts = LocalStorageService.getCachedProducts();
      // Return cached data if available
    }
    return Left(_handleDioError(e));
  }
}
```

## User Experience Features

### 1. Offline Indicator

The app shows a visual indicator of offline data status:

- **Green**: Fresh data available offline
- **Orange**: Data may be outdated
- **Cache Age**: Shows how old the cached data is

### 2. Pull-to-Refresh

Users can manually refresh data by pulling down on lists:

- **Online**: Fetches fresh data from API
- **Offline**: Shows cached data with refresh option
- **Mixed**: Combines cached and fresh data intelligently

### 3. Settings Integration

Cache management options in the Settings screen:

- **Offline Data Status**: View detailed cache information
- **Clear Cache**: Remove all cached data
- **Clear Search History**: Remove search queries
- **Cache Statistics**: Monitor storage usage

## Technical Implementation

### 1. Local Storage Service

```dart
class LocalStorageService {
  // Cache products with automatic timestamp
  static Future<void> cacheProducts(List<Product> products) async {
    final productsJson = products.map((p) => p.toJson()).toList();
    await _prefs.setString(_productsKey, jsonEncode(productsJson));
    await _updateLastFetchTime();
  }

  // Retrieve cached products with error handling
  static List<Product> getCachedProducts() {
    try {
      final productsString = _prefs.getString(_productsKey);
      if (productsString != null) {
        final productsList = jsonDecode(productsString) as List;
        return productsList.map((json) => 
          Product.fromJson(json as Map<String, dynamic>)
        ).toList();
      }
    } catch (e) {
      // Graceful fallback on parsing errors
    }
    return [];
  }
}
```

### 2. Cache Manager

```dart
class CacheManager {
  // Check if cache is still valid
  static bool isCacheValid() {
    final lastFetch = LocalStorageService.getLastFetchTime();
    if (lastFetch == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(lastFetch);
    return difference < AppConfig.cacheExpiration;
  }

  // Get comprehensive cache statistics
  static Map<String, dynamic> getCacheStats() {
    // Returns detailed information about cached data
  }
}
```

### 3. Offline Widgets

```dart
class OfflineIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Shows offline status with visual feedback
      // Includes cache age and refresh instructions
    );
  }
}
```

## Configuration

### Cache Expiration

Set in `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  // Cache expires after 1 hour
  static const Duration cacheExpiration = Duration(hours: 1);
}
```

### Storage Keys

All storage keys are centralized in `LocalStorageService`:

```dart
static const String _productsKey = 'cached_products';
static const String _recipesKey = 'cached_recipes';
static const String _categoriesKey = 'cached_categories';
static const String _lastFetchTimeKey = 'last_fetch_time';
```

## Best Practices

### 1. Error Handling

- **Graceful Degradation**: App continues working with cached data
- **User Feedback**: Clear indication of offline status
- **Recovery Options**: Easy ways to refresh or clear cache

### 2. Performance

- **Lazy Loading**: Data is cached only when needed
- **Efficient Storage**: JSON serialization for compact storage
- **Memory Management**: Automatic cleanup of expired data

### 3. User Experience

- **Transparent Operation**: Users know when they're viewing cached data
- **Manual Control**: Options to manage cache and refresh data
- **Consistent Interface**: Same UI whether online or offline

## Testing Offline Functionality

### 1. Enable Airplane Mode

1. Open the app and browse some data
2. Enable airplane mode
3. Navigate between screens - data should still be visible
4. Check offline indicator status

### 2. Test Cache Expiration

1. Wait for cache to expire (1 hour by default)
2. Verify offline indicator shows "expired" status
3. Test fallback to cached data

### 3. Test Cache Management

1. Go to Settings > Cache & Offline Data
2. View offline data status
3. Clear cache and verify data is removed
4. Refresh to restore data

## Future Enhancements

### 1. Background Sync

- **Periodic Updates**: Refresh cache in background
- **Push Notifications**: Alert users to new data
- **Smart Preloading**: Predict and cache likely-needed data

### 2. Advanced Caching

- **Compression**: Reduce storage footprint
- **Priority System**: Keep important data longer
- **Selective Sync**: Choose what to cache

### 3. Offline Actions

- **Queue System**: Store actions for later sync
- **Conflict Resolution**: Handle data conflicts gracefully
- **Offline Analytics**: Track offline usage patterns

## Troubleshooting

### Common Issues

1. **Cache Not Working**
   - Check if `LocalStorageService.init()` is called in `main.dart`
   - Verify SharedPreferences permissions
   - Check for storage space issues

2. **Data Not Persisting**
   - Ensure proper error handling in repository methods
   - Verify JSON serialization is working
   - Check cache expiration settings

3. **Performance Issues**
   - Monitor cache size and clear if needed
   - Check for memory leaks in storage operations
   - Optimize JSON parsing for large datasets

### Debug Information

Use the cache manager to get detailed information:

```dart
// Get cache statistics
final stats = CacheManager.getCacheStats();
print(stats);

// Check offline data availability
final availability = CacheManager.getOfflineDataAvailability();
print(availability);

// Get detailed summary
final summary = CacheManager.getOfflineDataSummary();
print(summary);
```

---

This offline functionality ensures that users can always access their data, providing a robust and reliable experience regardless of network conditions.
