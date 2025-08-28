import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/location.dart';
import '../../../shared/services/location_service.dart';

class DestinationSearchBar extends ConsumerStatefulWidget {
  final Function(Location) onDestinationSelected;

  const DestinationSearchBar({
    super.key,
    required this.onDestinationSelected,
  });

  @override
  ConsumerState<DestinationSearchBar> createState() => _DestinationSearchBarState();
}

class _DestinationSearchBarState extends ConsumerState<DestinationSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LocationService _locationService = LocationService();
  
  List<Location> _searchResults = [];
  bool _isSearching = false;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _controller.text.isEmpty) {
      setState(() {
        _showResults = true;
        _searchResults = _getPopularDestinations();
      });
    }
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _showResults = true;
        _searchResults = _getPopularDestinations();
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showResults = true;
    });

    // Simulate search delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted && _controller.text == query) {
      final results = await _searchLocations(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  Future<List<Location>> _searchLocations(String query) async {
    // Mock search results - in a real app, this would call a places API
    final mockResults = [
      Location(
        latitude: 37.7849,
        longitude: -122.4094,
        address: '456 Market St, San Francisco, CA',
        name: 'Market Street',
        placeId: 'place_1',
      ),
      Location(
        latitude: 37.7749,
        longitude: -122.4194,
        address: '789 Mission St, San Francisco, CA',
        name: 'Mission Street',
        placeId: 'place_2',
      ),
      Location(
        latitude: 37.7649,
        longitude: -122.4294,
        address: '321 Valencia St, San Francisco, CA',
        name: 'Valencia Street',
        placeId: 'place_3',
      ),
    ];

    // Filter results based on query
    return mockResults
        .where((location) =>
            location.name?.toLowerCase().contains(query.toLowerCase()) == true ||
            location.address?.toLowerCase().contains(query.toLowerCase()) == true)
        .toList();
  }

  List<Location> _getPopularDestinations() {
    return [
      const Location(
        latitude: 37.7849,
        longitude: -122.4094,
        address: 'San Francisco International Airport',
        name: 'SFO Airport',
        placeId: 'sfo_airport',
      ),
      const Location(
        latitude: 37.7949,
        longitude: -122.3994,
        address: 'Union Square, San Francisco, CA',
        name: 'Union Square',
        placeId: 'union_square',
      ),
      const Location(
        latitude: 37.8049,
        longitude: -122.4194,
        address: 'Fisherman\'s Wharf, San Francisco, CA',
        name: 'Fisherman\'s Wharf',
        placeId: 'fishermans_wharf',
      ),
    ];
  }

  void _onLocationSelected(Location location) {
    _controller.text = location.name ?? location.address ?? '';
    _focusNode.unfocus();
    setState(() {
      _showResults = false;
    });
    widget.onDestinationSelected(location);
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _showResults = false;
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Where to?',
              hintStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 24,
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM,
                vertical: AppConstants.paddingM,
              ),
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        if (_showResults) ...[
          const SizedBox(height: AppConstants.paddingS),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _isSearching
                ? const Padding(
                    padding: EdgeInsets.all(AppConstants.paddingL),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final location = _searchResults[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                        ),
                        title: Text(
                          location.name ?? 'Unknown location',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          location.address ?? '',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        onTap: () => _onLocationSelected(location),
                      );
                    },
                  ),
          ),
        ],
      ],
    );
  }
}