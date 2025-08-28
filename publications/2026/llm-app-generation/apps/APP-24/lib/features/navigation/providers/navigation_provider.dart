import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/models.dart';

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState());

  void startNavigation(WazeRoute route) {
    state = state.copyWith(
      currentRoute: route,
      isNavigating: true,
      navigationStartTime: DateTime.now(),
      currentStepIndex: 0,
    );
  }

  void stopNavigation() {
    state = const NavigationState();
  }

  void updateLocation(Location location) {
    if (!state.isNavigating || state.currentRoute == null) return;

    state = state.copyWith(
      currentLocation: location,
      currentSpeed: location.speed,
      currentBearing: location.bearing,
    );

    _updateNavigationProgress();
  }

  void _updateNavigationProgress() {
    if (state.currentRoute == null || state.currentLocation == null) return;

    final currentStep = state.currentStep;
    if (currentStep == null) return;

    // Calculate distance to next step
    final distanceToStep = state.currentLocation!.distanceTo(currentStep.endLocation);
    
    state = state.copyWith(
      distanceToNextStep: distanceToStep,
      timeToNextStep: _calculateTimeToStep(distanceToStep, state.currentSpeed ?? 0),
    );

    // Check if we should move to next step
    if (distanceToStep < 20 && state.currentStepIndex < state.currentRoute!.legs.first.steps.length - 1) {
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex + 1,
      );
    }
  }

  int _calculateTimeToStep(double distance, double speed) {
    if (speed <= 0) return 0;
    return (distance / speed).round();
  }

  void nextStep() {
    if (state.currentRoute == null) return;
    
    final maxSteps = state.currentRoute!.legs.first.steps.length;
    if (state.currentStepIndex < maxSteps - 1) {
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex + 1,
      );
    }
  }

  void previousStep() {
    if (state.currentStepIndex > 0) {
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex - 1,
      );
    }
  }

  void setRerouting(bool isRerouting) {
    state = state.copyWith(isRerouting: isRerouting);
  }

  void updateRoute(WazeRoute newRoute) {
    state = state.copyWith(
      currentRoute: newRoute,
      currentStepIndex: 0,
      isRerouting: false,
    );
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
});