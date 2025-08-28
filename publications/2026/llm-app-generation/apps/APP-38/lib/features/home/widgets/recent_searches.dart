import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/search.dart';

class RecentSearches extends StatelessWidget {
  final List<RecentSearch> searches;
  final Function(RecentSearch) onSearchTap;

  const RecentSearches({
    super.key,
    required this.searches,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent searches',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Clear recent searches
                },
                child: const Text('Clear all'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: searches.length,
              itemBuilder: (context, index) {
                final search = searches[index];
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => onSearchTap(search),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightGrey,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getServiceIcon(search.serviceType),
                                size: 16,
                                color: AppTheme.primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  search.destination,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getServiceLabel(search.serviceType),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatSearchDate(search.searchDate),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String serviceType) {
    switch (serviceType) {
      case 'stays':
        return Icons.hotel;
      case 'flights':
        return Icons.flight;
      case 'car_rental':
        return Icons.directions_car;
      case 'attractions':
        return Icons.local_activity;
      case 'taxis':
        return Icons.local_taxi;
      default:
        return Icons.search;
    }
  }

  String _getServiceLabel(String serviceType) {
    switch (serviceType) {
      case 'stays':
        return 'Stays';
      case 'flights':
        return 'Flights';
      case 'car_rental':
        return 'Car rental';
      case 'attractions':
        return 'Attractions';
      case 'taxis':
        return 'Taxis';
      default:
        return 'Search';
    }
  }

  String _formatSearchDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}