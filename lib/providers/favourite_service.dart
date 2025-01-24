import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  /// Load favorites for the current user
  Future<void> loadFavorites(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedFavorites =
        prefs.getStringList('favorites_$userId') ?? [];
    state = storedFavorites.toSet();
  }

  /// Add a product to favorites for a specific user
  Future<void> addToFavorites({required String userId, required String productId}) async {
    final prefs = await SharedPreferences.getInstance();
    // Fetch the current list of favorites for the user
    final List<String> favorites =
        prefs.getStringList('favorites_$userId') ?? [];

    // Add the new product if it doesn't already exist
    if (!favorites.contains(productId)) {
      favorites.add(productId);
      await prefs.setStringList('favorites_$userId', favorites);

      // Update state
      state = favorites.toSet();
    }
  }

  /// Remove a product from favorites for a specific user
  Future<void> removeFromFavorites({required String userId, required String productId}) async {
    final prefs = await SharedPreferences.getInstance();
    // Fetch the current list of favorites for the user
    final List<String> favorites =
        prefs.getStringList('favorites_$userId') ?? [];

    if (favorites.contains(productId)) {
      favorites.remove(productId);
      await prefs.setStringList('favorites_$userId', favorites);

      // Update state
      state = favorites.toSet();
    }
  }
}

// Create a Riverpod provider for the FavoritesNotifier
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);
