import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/cookie.dart';

class WeeklyMenuCarousel extends StatelessWidget {
  final Function(Cookie) onCookieTap;

  const WeeklyMenuCarousel({
    super.key,
    required this.onCookieTap,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data for now
    final mockCookies = [
      Cookie(
        id: '1',
        name: 'Chocolate Chip',
        description: 'Classic chocolate chip cookie with premium chocolate chips',
        imageUrl: 'https://via.placeholder.com/300x200/FF69B4/FFFFFF?text=Chocolate+Chip',
        price: 4.50,
        ingredients: ['Flour', 'Butter', 'Sugar', 'Chocolate Chips'],
        allergens: ['Gluten', 'Dairy'],
        calories: 320,
        isWeeklySpecial: true,
      ),
      Cookie(
        id: '2',
        name: 'Sugar Cookie',
        description: 'Soft and sweet sugar cookie with pink frosting',
        imageUrl: 'https://via.placeholder.com/300x200/FFB6C1/FFFFFF?text=Sugar+Cookie',
        price: 4.00,
        ingredients: ['Flour', 'Butter', 'Sugar', 'Frosting'],
        allergens: ['Gluten', 'Dairy'],
        calories: 280,
        isWeeklySpecial: true,
      ),
      Cookie(
        id: '3',
        name: 'Snickerdoodle',
        description: 'Cinnamon sugar cookie with a soft, chewy texture',
        imageUrl: 'https://via.placeholder.com/300x200/FFC0CB/FFFFFF?text=Snickerdoodle',
        price: 4.25,
        ingredients: ['Flour', 'Butter', 'Sugar', 'Cinnamon'],
        allergens: ['Gluten', 'Dairy'],
        calories: 300,
        isWeeklySpecial: true,
      ),
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      itemCount: mockCookies.length,
      itemBuilder: (context, index) {
        final cookie = mockCookies[index];
        return Container(
          width: 250,
          margin: const EdgeInsets.only(right: AppConstants.defaultPadding),
          child: Card(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              onTap: () => onCookieTap(cookie),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cookie Image
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppConstants.borderRadius),
                      ),
                      color: AppTheme.crumblLightPink,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppConstants.borderRadius),
                      ),
                      child: Image.network(
                        cookie.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.crumblLightPink,
                            child: const Center(
                              child: Icon(
                                Icons.cookie,
                                size: 48,
                                color: AppTheme.crumblPink,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Cookie Info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cookie.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cookie.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGray,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${cookie.price.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.crumblPink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.crumblLightPink,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${cookie.calories} cal',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.crumblDarkPink,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}