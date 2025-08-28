import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/property.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: property.images.isNotEmpty 
                        ? property.images.first 
                        : 'https://picsum.photos/400/200',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: AppTheme.lightGrey,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: AppTheme.lightGrey,
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
                
                // Wishlist Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        property.isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: property.isWishlisted ? AppTheme.errorRed : AppTheme.darkGrey,
                      ),
                      onPressed: () {
                        // TODO: Toggle wishlist
                      },
                    ),
                  ),
                ),
                
                // Discount Badge
                if (property.discountPercentage != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${property.discountPercentage!.round()}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Property Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Name and Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                ...List.generate(
                                  property.starRating,
                                  (index) => const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: AppTheme.warningYellow,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  property.type,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.mediumGrey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getScoreColor(property.reviewScore),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              property.reviewScore.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            property.reviewScoreText,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${property.reviewCount} reviews',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppTheme.mediumGrey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${property.city}, ${property.country}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mediumGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Amenities
                  if (property.amenities.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: property.amenities.take(3).map((amenity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.lightGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            amenity,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.darkGrey,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  
                  const SizedBox(height: 12),
                  
                  // Booking Policies
                  Row(
                    children: [
                      if (property.freeCancellation)
                        _buildPolicyChip(
                          'Free cancellation',
                          Icons.cancel_outlined,
                          AppTheme.successGreen,
                        ),
                      if (property.bookNowPayLater)
                        _buildPolicyChip(
                          'Book now, pay later',
                          Icons.schedule,
                          AppTheme.primaryBlue,
                        ),
                      if (property.geniusDiscount != null)
                        _buildPolicyChip(
                          property.geniusDiscount!,
                          Icons.star,
                          AppTheme.accentOrange,
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (property.rooms.isNotEmpty && property.rooms.first.hasDiscount)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${property.rooms.first.originalPrice!.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppTheme.mediumGrey,
                              ),
                            ),
                            Text(
                              '\$${property.lowestPrice.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.priceColor,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          '\$${property.lowestPrice.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.priceColor,
                          ),
                        ),
                      Text(
                        'per night',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyChip(String label, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 9.0) return AppTheme.successGreen;
    if (score >= 8.0) return AppTheme.primaryBlue;
    if (score >= 7.0) return AppTheme.accentOrange;
    return AppTheme.mediumGrey;
  }
}