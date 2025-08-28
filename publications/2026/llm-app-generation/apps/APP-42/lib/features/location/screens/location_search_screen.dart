import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/weather_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/weather_data.dart';
import '../widgets/location_search_bar.dart';
import '../widgets/saved_locations_list.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Location> _searchResults = [];
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query != _searchQuery) {
      _searchQuery = query;
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          _searchResults.clear();
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.length < 2) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final weatherProvider = context.read<WeatherProvider>();
      final results = await weatherProvider.searchLocations(query);
      
      if (mounted && query == _searchQuery) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults.clear();
          _isSearching = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching locations: ${e.toString()}'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
    }
  }

  Future<void> _selectLocation(Location location) async {
    try {
      final weatherProvider = context.read<WeatherProvider>();
      
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      // Load weather for selected location
      await weatherProvider.loadWeatherForLocation(location);
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
        // Close search screen
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading weather: ${e.toString()}'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
    }
  }

  Future<void> _saveLocation(Location location) async {
    try {
      final weatherProvider = context.read<WeatherProvider>();
      await weatherProvider.saveLocation(location);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location saved successfully'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving location: ${e.toString()}'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Locations'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search bar
          LocationSearchBar(
            controller: _searchController,
            onClear: () {
              _searchController.clear();
              setState(() {
                _searchResults.clear();
                _isSearching = false;
                _searchQuery = '';
              });
            },
          ),
          
          // Content
          Expanded(
            child: _searchQuery.isNotEmpty
                ? _buildSearchResults()
                : _buildSavedLocations(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No locations found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different term',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final location = _searchResults[index];
        final weatherProvider = context.watch<WeatherProvider>();
        final isLocationSaved = weatherProvider.isLocationSaved(location);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(
              Icons.location_on,
              color: AppTheme.primaryBlue,
            ),
            title: Text(
              location.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(location.displayName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLocationSaved)
                  IconButton(
                    icon: const Icon(Icons.bookmark_add),
                    onPressed: () => _saveLocation(location),
                    tooltip: 'Save location',
                  )
                else
                  Icon(
                    Icons.bookmark,
                    color: AppTheme.successGreen,
                  ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => _selectLocation(location),
          ),
        );
      },
    );
  }

  Widget _buildSavedLocations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.bookmark,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Saved Locations',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SavedLocationsList(
            onLocationSelected: _selectLocation,
          ),
        ),
      ],
    );
  }
}