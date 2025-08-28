import 'package:flutter/foundation.dart';
import '../../../shared/models/appointment.dart';

class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Appointment> get appointments => _appointments;
  List<Appointment> get upcomingAppointments => 
      _appointments.where((apt) => apt.isUpcoming).toList();
  List<Appointment> get pastAppointments => 
      _appointments.where((apt) => apt.isPast).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAppointments() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _appointments = [
        Appointment(
          id: '1',
          patientId: '1',
          providerId: 'dr1',
          providerName: 'Dr. Sarah Johnson',
          department: 'Cardiology',
          reason: 'Annual Checkup',
          dateTime: DateTime.now().add(const Duration(days: 3)),
          status: AppointmentStatus.scheduled,
          type: AppointmentType.inPerson,
          location: 'Main Hospital - Room 205',
        ),
        Appointment(
          id: '2',
          patientId: '1',
          providerId: 'dr2',
          providerName: 'Dr. Michael Chen',
          department: 'Dermatology',
          reason: 'Skin Check',
          dateTime: DateTime.now().add(const Duration(days: 10)),
          status: AppointmentStatus.scheduled,
          type: AppointmentType.video,
        ),
      ];
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load appointments';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> scheduleAppointment(Appointment appointment) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _appointments.add(appointment);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to schedule appointment';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelAppointment(String appointmentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
      if (index != -1) {
        _appointments.removeAt(index);
      }
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to cancel appointment';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}