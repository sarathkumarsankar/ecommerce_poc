import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product_x/models/product.dart';
import 'package:product_x/providers/auth_provider.dart';
import 'package:product_x/providers/favourite_service.dart';
import 'package:product_x/widgets/custom_appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(product.id.toString());
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: CustomAppBar(title: product.title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(
                context, isFavorite, favoritesNotifier, authState.userId ?? ""),
            _buildProductDetails(context),
            if (product.images.length > 1)
              _buildAdditionalImages(context, product.images),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(
    BuildContext context,
    bool isFavorite,
    FavoritesNotifier favoritesNotifier,
    String userID,
  ) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: product.images.isNotEmpty ? product.images[0] : '',
          fit: BoxFit.cover,
          width: double.infinity,
          height: 300.0,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error, size: 40)),
        ),
        Positioned(
          top: 16.0,
          right: 16.0,
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (isFavorite) {
                  favoritesNotifier.removeFromFavorites(
                      userId: userID, productId: product.id.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Removed from favorites!')),
                  );
                } else {
                  favoritesNotifier.addToFavorites(
                      userId: userID, productId: product.id.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to favorites!')),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${product.price}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    product.rating.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Icon(Icons.category,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8.0),
              Text(
                'Category: ${product.category}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            'Description:',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 8.0),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalImages(BuildContext context, List<String> images) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More Images',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 100.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8.0),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                    width: 100.0,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 40),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
