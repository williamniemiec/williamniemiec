import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_provider.dart';
import '../../../shared/models/location.dart';
import '../../../shared/models/trip.dart';
import '../../../shared/services/trip_service.dart';
import '../widgets/ride_options_list.dart';
import '../widgets/trip_summary_card.dart';
import '../../trip/screens/trip_screen.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Location pickup;
  final Location destination;

  const BookingScreen({
    super.key,
    required this.pickup,
    required this.destination,
  });

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  RideOption? _selectedRideOption;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRideOptions();
    });
  }

  void _loadRideOptions() {
    ref.read(rideOptionsProvider.notifier).loadRideOptions(
          widget.pickup,
          widget.destination,
        );
  }

  @override
  Widget build(BuildContext context) {
    final rideOptions = ref.watch(rideOptionsProvider);
    final paymentMethods = ref.watch(paymentMethodsProvider);
    final defaultPaymentMethod = paymentMethods.where((pm) => pm.isDefault).firstOrNull;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Choose a ride'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(destinationProvider.notifier).clearDestination();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          // Trip Summary
          TripSummaryCard(
            pickup: widget.pickup,
            destination: widget.destination,
          ),
          
          // Ride Options
          Expanded(
            child: rideOptions.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RideOptionsList(
                    options: rideOptions,
                    selectedOption: _selectedRideOption,
                    onOptionSelected: (option) {
                      setState(() {
                        _selectedRideOption = option;
                      });
                    },
                  ),
          ),
          
          // Payment Method & Book Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Payment Method
                  if (defaultPaymentMethod != null)
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingM),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getPaymentIcon(defaultPaymentMethod.type),
                            size: AppConstants.iconM,
                          ),
                          const SizedBox(width: AppConstants.paddingM),
                          Expanded(
                            child: Text(
                              defaultPaymentMethod.displayName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: AppConstants.paddingM),
                  
                  // Book Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedRideOption != null && !_isBooking
                          ? _bookRide
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingM,
                        ),
                      ),
                      child: _isBooking
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              _selectedRideOption != null
                                  ? 'Request ${_selectedRideOption!.name}'
                                  : 'Select a ride option',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _bookRide() async {
    if (_selectedRideOption == null) return;

    setState(() {
      _isBooking = true;
    });

    try {
      final tripService = TripService();
      final paymentMethods = ref.read(paymentMethodsProvider);
      final defaultPaymentMethod = paymentMethods.where((pm) => pm.isDefault).firstOrNull;

      final trip = await tripService.requestTrip(
        userId: 'user_123', // In a real app, get from auth
        pickup: widget.pickup,
        destination: widget.destination,
        rideType: _selectedRideOption!.type,
        paymentMethodId: defaultPaymentMethod?.id,
      );

      if (mounted) {
        // Navigate to trip screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TripScreen(trip: trip),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book ride: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }

  IconData _getPaymentIcon(String type) {
    switch (type) {
      case 'credit_card':
      case 'debit_card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'apple_pay':
        return Icons.phone_iphone;
      case 'google_pay':
        return Icons.android;
      default:
        return Icons.payment;
    }
  }
}