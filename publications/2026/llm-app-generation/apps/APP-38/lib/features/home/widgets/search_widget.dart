import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/search.dart';

class SearchWidget extends StatefulWidget {
  final String serviceType;
  final Function(SearchCriteria) onSearch;

  const SearchWidget({
    super.key,
    required this.serviceType,
    required this.onSearch,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _destinationController = TextEditingController();
  DateTime _checkInDate = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 3));
  int _numberOfGuests = 2;
  int _numberOfRooms = 1;

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _selectCheckInDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _checkInDate = date;
        // Ensure check-out is after check-in
        if (_checkOutDate.isBefore(_checkInDate.add(const Duration(days: 1)))) {
          _checkOutDate = _checkInDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectCheckOutDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _checkOutDate,
      firstDate: _checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _checkOutDate = date;
      });
    }
  }

  void _showGuestRoomSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Guests and Rooms',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // Guests
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Guests',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _numberOfGuests > 1 ? () {
                          setModalState(() {
                            _numberOfGuests--;
                          });
                        } : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$_numberOfGuests',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: _numberOfGuests < 16 ? () {
                          setModalState(() {
                            _numberOfGuests++;
                          });
                        } : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Rooms
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rooms',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _numberOfRooms > 1 ? () {
                          setModalState(() {
                            _numberOfRooms--;
                          });
                        } : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$_numberOfRooms',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: _numberOfRooms < 5 ? () {
                          setModalState(() {
                            _numberOfRooms++;
                          });
                        } : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSearch() {
    if (_destinationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a destination'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    final criteria = SearchCriteria(
      destination: _destinationController.text.trim(),
      checkInDate: _checkInDate,
      checkOutDate: _checkOutDate,
      numberOfGuests: _numberOfGuests,
      numberOfRooms: _numberOfRooms,
      serviceType: widget.serviceType,
    );

    widget.onSearch(criteria);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Destination
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                hintText: 'Where are you going?',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppTheme.mediumGrey.withOpacity(0.7),
                ),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          
          const Divider(height: 1),
          
          // Dates and Guests
          IntrinsicHeight(
            child: Row(
              children: [
                // Check-in Date
                Expanded(
                  child: GestureDetector(
                    onTap: _selectCheckInDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Check-in',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM dd').format(_checkInDate),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const VerticalDivider(width: 1),
                
                // Check-out Date
                Expanded(
                  child: GestureDetector(
                    onTap: _selectCheckOutDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Check-out',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM dd').format(_checkOutDate),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const VerticalDivider(width: 1),
                
                // Guests and Rooms
                Expanded(
                  child: GestureDetector(
                    onTap: _showGuestRoomSelector,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guests',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_numberOfGuests guests, $_numberOfRooms room${_numberOfRooms > 1 ? 's' : ''}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Search Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _handleSearch,
              child: const Text('Search'),
            ),
          ),
        ],
      ),
    );
  }
}