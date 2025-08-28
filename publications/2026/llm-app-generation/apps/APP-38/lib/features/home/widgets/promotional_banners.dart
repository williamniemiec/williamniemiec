import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PromotionalBanners extends StatefulWidget {
  const PromotionalBanners({super.key});

  @override
  State<PromotionalBanners> createState() => _PromotionalBannersState();
}

class _PromotionalBannersState extends State<PromotionalBanners> {
  int _currentIndex = 0;

  final List<PromoBanner> _banners = [
    PromoBanner(
      title: 'Mobile-only deals',
      subtitle: 'Save up to 20% on your next booking',
      description: 'Exclusive discounts available only on the mobile app',
      imageUrl: 'https://picsum.photos/400/200?random=1',
      backgroundColor: AppTheme.primaryBlue,
      textColor: Colors.white,
    ),
    PromoBanner(
      title: 'Genius rewards',
      subtitle: 'Unlock instant savings',
      description: 'Join Genius and enjoy 10% or more off stays',
      imageUrl: 'https://picsum.photos/400/200?random=2',
      backgroundColor: AppTheme.accentOrange,
      textColor: Colors.white,
    ),
    PromoBanner(
      title: 'Last-minute deals',
      subtitle: 'Book tonight, save big',
      description: 'Great deals on stays for tonight and tomorrow',
      imageUrl: 'https://picsum.photos/400/200?random=3',
      backgroundColor: AppTheme.successGreen,
      textColor: Colors.white,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              itemCount: _banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        // Background Image
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: banner.backgroundColor,
                            image: DecorationImage(
                              image: NetworkImage(banner.imageUrl),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                banner.backgroundColor.withOpacity(0.7),
                                BlendMode.overlay,
                              ),
                            ),
                          ),
                        ),
                        
                        // Content
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                banner.title,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: banner.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                banner.subtitle,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: banner.textColor.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                banner.description,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: banner.textColor.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Handle banner action
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: banner.backgroundColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                child: const Text('Learn More'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _banners.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? AppTheme.primaryBlue
                      : AppTheme.mediumGrey.withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class PromoBanner {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final Color backgroundColor;
  final Color textColor;

  PromoBanner({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.backgroundColor,
    required this.textColor,
  });
}