import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.searchBarHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            // TODO: Navigate to search screen
            _showSearchBottomSheet(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppStrings.whereToHint,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                Icon(
                  Icons.mic,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Search input
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: AppStrings.searchPlaces,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                onChanged: (value) {
                  // TODO: Implement search
                },
              ),
            ),
            
            // Recent searches and suggestions
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSectionHeader(context, 'Recent'),
                  _buildSearchItem(context, Icons.history, 'Home', '123 Main St'),
                  _buildSearchItem(context, Icons.history, 'Work', '456 Office Blvd'),
                  _buildSearchItem(context, Icons.history, 'Starbucks', '789 Coffee Ave'),
                  
                  const SizedBox(height: 24),
                  
                  _buildSectionHeader(context, 'Suggestions'),
                  _buildSearchItem(context, Icons.local_gas_station, 'Gas stations', 'Nearby'),
                  _buildSearchItem(context, Icons.local_parking, 'Parking', 'Near destination'),
                  _buildSearchItem(context, Icons.restaurant, 'Restaurants', 'Popular nearby'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSearchItem(BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        // TODO: Handle search item selection
        Navigator.pop(context);
      },
    );
  }
}