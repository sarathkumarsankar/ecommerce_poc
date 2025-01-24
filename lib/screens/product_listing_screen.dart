import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_x/models/product.dart';
import 'package:product_x/providers/auth_provider.dart';
import 'package:product_x/providers/product_provider.dart';
import 'package:product_x/screens/product_detail_screen.dart';
import 'package:product_x/providers/favourite_service.dart';
import 'package:product_x/widgets/custom_appbar.dart';

final productListProvider = FutureProvider((ref) {
  final repository = ref.read(productRepositoryProvider);
  return repository.fetchProducts();
});

class ProductListingScreen extends ConsumerWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final favorites = ref.watch(favoritesProvider);
    final authState = ref.watch(authProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 2 : 1;

    // Load favorites for the current user
    if (authState.userId != null) {
      favoritesNotifier.loadFavorites(authState.userId!);
    }
    return Scaffold(
      appBar: const CustomAppBar(title: 'Shopping'),
      body: productsAsync.when(
        data: (products) => _buildProductGrid(
            context: context,
            products: products,
            favorites: favorites,
            favoritesNotifier: favoritesNotifier,
            crossAxisCount: crossAxisCount,
            userID: authState.userId ?? ""),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildErrorScreen(error, ref),
      ),
    );
  }

  Widget _buildProductGrid({
    required BuildContext context,
    required List<Product> products,
    required Set<String> favorites,
    required FavoritesNotifier favoritesNotifier,
    required int crossAxisCount,
    required String userID,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.5,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isFavorite = favorites.contains(product.id.toString());

        return ProductCard(
          product: product,
          isFavorite: isFavorite,
          onFavoriteToggle: () async {
            if (isFavorite) {
              await favoritesNotifier.removeFromFavorites(
                  userId: userID, productId: product.id.toString());
            } else {
              await favoritesNotifier.addToFavorites(
                  userId: userID, productId: product.id.toString());
            }
          },
        );
      },
    );
  }
}

Widget _buildErrorScreen(Object error, WidgetRef ref) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Failed to load products: $error'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => ref.refresh(productListProvider),
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(context),
            _buildProductDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
        child: CachedNetworkImage(
          imageUrl: product.images[0],
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, size: 40),
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  '\$${product.price}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}
