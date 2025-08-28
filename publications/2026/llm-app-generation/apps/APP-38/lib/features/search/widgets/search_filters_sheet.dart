import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/search.dart';

class SearchFiltersSheet extends StatefulWidget {
  final SearchFilters currentFilters;
  final Function(SearchFilters) onFiltersApplied;

  const SearchFiltersSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<SearchFiltersSheet> createState() => _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends State<SearchFiltersSheet> {
  late SearchFilters _filters;
  RangeValues _priceRange = const RangeValues(0, 500);

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
    _priceRange = RangeValues(
      _filters.minPrice ?? 0,
      _filters.maxPrice ?? 500,
    );
  }

  void _applyFilters() {
    final updatedFilters = _filters.copyWith(
      minPrice: _priceRange.start > 0 ? _priceRange.start : null,
      maxPrice: _priceRange.end < 500 ? _priceRange.end : null,
    );
    widget.onFiltersApplied(updatedFilters);
    Navigator.pop(context);
  }

  void _clearAllFilters() {
    setState(() {
      _filters = const SearchFilters();
      _priceRange = const RangeValues(0, 500);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.mediumGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: _clearAllFilters,
                      child: const Text('Clear all'),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Filters Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Price Range
                    _buildSectionTitle('Price per night'),
                    const SizedBox(height: 16),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 500,
                      divisions: 50,
                      labels: RangeLabels(
                        '\$${_priceRange.start.round()}',
                        '\$${_priceRange.end.round()}',
                      ),
                      onChanged: (values) {
                        setState(() {
                          _priceRange = values;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${_priceRange.start.round()}'),
                        Text('\$${_priceRange.end.round()}'),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Star Rating
                    _buildSectionTitle('Star rating'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: AppConstants.starRatings.map((rating) {
                        final isSelected = _filters.starRatings.contains(int.parse(rating));
                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...List.generate(
                                int.parse(rating),
                                (index) => const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppTheme.warningYellow,
                                ),
                              ),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              final ratings = List<int>.from(_filters.starRatings);
                              if (selected) {
                                ratings.add(int.parse(rating));
                              } else {
                                ratings.remove(int.parse(rating));
                              }
                              _filters = _filters.copyWith(starRatings: ratings);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Property Type
                    _buildSectionTitle('Property type'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.propertyTypes.map((type) {
                        final isSelected = _filters.propertyTypes.contains(type);
                        return FilterChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              final types = List<String>.from(_filters.propertyTypes);
                              if (selected) {
                                types.add(type);
                              } else {
                                types.remove(type);
                              }
                              _filters = _filters.copyWith(propertyTypes: types);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Amenities
                    _buildSectionTitle('Amenities'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.amenities.map((amenity) {
                        final isSelected = _filters.amenities.contains(amenity);
                        return FilterChip(
                          label: Text(amenity),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              final amenities = List<String>.from(_filters.amenities);
                              if (selected) {
                                amenities.add(amenity);
                              } else {
                                amenities.remove(amenity);
                              }
                              _filters = _filters.copyWith(amenities: amenities);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Guest Rating
                    _buildSectionTitle('Guest rating'),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _buildRatingOption('Wonderful: 9+', 9.0),
                        _buildRatingOption('Very good: 8+', 8.0),
                        _buildRatingOption('Good: 7+', 7.0),
                        _buildRatingOption('Pleasant: 6+', 6.0),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Booking Policies
                    _buildSectionTitle('Booking policies'),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        CheckboxListTile(
                          title: const Text('Free cancellation'),
                          subtitle: const Text('Cancel for free before check-in'),
                          value: _filters.freeCancellation,
                          onChanged: (value) {
                            setState(() {
                              _filters = _filters.copyWith(freeCancellation: value ?? false);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('Book now, pay later'),
                          subtitle: const Text('Reserve now and pay at the property'),
                          value: _filters.bookNowPayLater,
                          onChanged: (value) {
                            setState(() {
                              _filters = _filters.copyWith(bookNowPayLater: value ?? false);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('Breakfast included'),
                          subtitle: const Text('Properties that include breakfast'),
                          value: _filters.breakfastIncluded,
                          onChanged: (value) {
                            setState(() {
                              _filters = _filters.copyWith(breakfastIncluded: value ?? false);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 100), // Space for button
                  ],
                ),
              ),
              
              // Apply Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppTheme.lightGrey)),
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      child: Text('Show results (${_getActiveFilterCount()})'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRatingOption(String label, double rating) {
    final isSelected = _filters.minReviewScore == rating;
    return RadioListTile<double>(
      title: Text(label),
      value: rating,
      groupValue: _filters.minReviewScore,
      onChanged: (value) {
        setState(() {
          _filters = _filters.copyWith(minReviewScore: value);
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_priceRange.start > 0 || _priceRange.end < 500) count++;
    if (_filters.starRatings.isNotEmpty) count++;
    if (_filters.propertyTypes.isNotEmpty) count++;
    if (_filters.amenities.isNotEmpty) count++;
    if (_filters.minReviewScore != null) count++;
    if (_filters.freeCancellation) count++;
    if (_filters.bookNowPayLater) count++;
    if (_filters.breakfastIncluded) count++;
    return count;
  }
}