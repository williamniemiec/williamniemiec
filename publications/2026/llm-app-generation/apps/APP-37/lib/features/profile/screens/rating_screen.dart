import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_provider.dart';
import '../../../shared/models/trip.dart';
import '../../../shared/services/trip_service.dart';
import '../../home/screens/home_screen.dart';

class RatingScreen extends ConsumerStatefulWidget {
  final Trip trip;

  const RatingScreen({
    super.key,
    required this.trip,
  });

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  int _rating = 5;
  double _tip = 0.0;
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  final List<double> _tipOptions = [0.0, 1.0, 2.0, 3.0, 5.0];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate your trip'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver Info
            if (widget.trip.driver != null) ...[
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: widget.trip.driver!.profileImageUrl != null
                          ? NetworkImage(widget.trip.driver!.profileImageUrl!)
                          : null,
                      child: widget.trip.driver!.profileImageUrl == null
                          ? Text(
                              widget.trip.driver!.firstName[0],
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: AppConstants.paddingM),
                    Text(
                      widget.trip.driver!.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingS),
                    Text(
                      widget.trip.driver!.vehicle.displayName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingXL),
            ],
            
            // Rating
            const Text(
              'How was your trip?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.star,
                      size: 40,
                      color: index < _rating ? Colors.amber : Colors.grey[300],
                    ),
                  ),
                );
              }),
            ),
            
            const SizedBox(height: AppConstants.paddingXL),
            
            // Feedback
            const Text(
              'Leave feedback (optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Tell us about your experience...',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingXL),
            
            // Tip
            const Text(
              'Add a tip',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            
            Wrap(
              spacing: AppConstants.paddingS,
              children: _tipOptions.map((tip) {
                final isSelected = _tip == tip;
                return ChoiceChip(
                  label: Text(tip == 0.0 ? 'No tip' : '\$${tip.toStringAsFixed(0)}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _tip = tip;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            
            const SizedBox(height: AppConstants.paddingXL),
            
            // Trip Summary
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trip Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingS),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Fare'),
                      Text('\$${widget.trip.actualFare?.toStringAsFixed(2) ?? widget.trip.estimatedFare?.toStringAsFixed(2) ?? '0.00'}'),
                    ],
                  ),
                  if (_tip > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tip'),
                        Text('\$${_tip.toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '\$${((widget.trip.actualFare ?? widget.trip.estimatedFare ?? 0.0) + _tip).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingXL),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRating,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Submit Rating'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final tripService = TripService();
      await tripService.rateTrip(
        widget.trip.id,
        _rating,
        feedback: _feedbackController.text.isNotEmpty ? _feedbackController.text : null,
        tip: _tip > 0 ? _tip : null,
      );

      // Clear current trip
      ref.read(currentTripProvider.notifier).clearTrip();
      ref.read(destinationProvider.notifier).clearDestination();

      if (mounted) {
        // Navigate back to home
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit rating: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}