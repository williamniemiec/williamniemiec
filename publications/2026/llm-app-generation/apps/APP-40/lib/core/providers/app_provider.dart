import 'package:flutter/material.dart';
import '../../shared/models/device.dart';
import '../../shared/models/room.dart';
import '../../shared/models/routine.dart';
import '../../shared/models/activity.dart';
import '../constants/app_constants.dart';

class AppProvider extends ChangeNotifier {
  // App State
  String _homeName = AppConstants.defaultHomeName;
  String _userName = AppConstants.defaultUserName;
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  int _currentTabIndex = 0;

  // Data
  List<Device> _devices = [];
  List<Room> _rooms = [];
  List<Routine> _routines = [];
  List<Activity> _activities = [];
  List<String> _favoriteDeviceIds = [];

  // Loading States
  bool _isLoading = false;
  bool _isDevicesLoading = false;
  bool _isRoutinesLoading = false;
  bool _isActivitiesLoading = false;

  // Error States
  String? _errorMessage;

  // Getters
  String get homeName => _homeName;
  String get userName => _userName;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  int get currentTabIndex => _currentTabIndex;

  List<Device> get devices => List.unmodifiable(_devices);
  List<Room> get rooms => List.unmodifiable(_rooms);
  List<Routine> get routines => List.unmodifiable(_routines);
  List<Activity> get activities => List.unmodifiable(_activities);
  List<String> get favoriteDeviceIds => List.unmodifiable(_favoriteDeviceIds);

  bool get isLoading => _isLoading;
  bool get isDevicesLoading => _isDevicesLoading;
  bool get isRoutinesLoading => _isRoutinesLoading;
  bool get isActivitiesLoading => _isActivitiesLoading;
  String? get errorMessage => _errorMessage;

  // Computed Properties
  List<Device> get favoriteDevices {
    return _devices.where((device) => _favoriteDeviceIds.contains(device.id)).toList();
  }

  List<Device> get onlineDevices {
    return _devices.where((device) => device.status == DeviceStatus.online).toList();
  }

  List<Device> get offlineDevices {
    return _devices.where((device) => device.status == DeviceStatus.offline).toList();
  }

  List<Routine> get householdRoutines {
    return _routines.where((routine) => routine.type == RoutineType.household).toList();
  }

  List<Routine> get personalRoutines {
    return _routines.where((routine) => routine.type == RoutineType.personal).toList();
  }

  List<Activity> get unreadActivities {
    return _activities.where((activity) => !activity.isRead).toList();
  }

  List<Activity> get criticalActivities {
    return _activities.where((activity) => activity.priority == ActivityPriority.critical).toList();
  }

  // App Settings Methods
  void setHomeName(String name) {
    _homeName = name;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }

  void setCurrentTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // Device Methods
  void setDevices(List<Device> devices) {
    _devices = devices;
    notifyListeners();
  }

  void addDevice(Device device) {
    _devices.add(device);
    notifyListeners();
  }

  void updateDevice(Device updatedDevice) {
    final index = _devices.indexWhere((device) => device.id == updatedDevice.id);
    if (index != -1) {
      _devices[index] = updatedDevice;
      notifyListeners();
    }
  }

  void removeDevice(String deviceId) {
    _devices.removeWhere((device) => device.id == deviceId);
    _favoriteDeviceIds.remove(deviceId);
    notifyListeners();
  }

  Device? getDeviceById(String deviceId) {
    try {
      return _devices.firstWhere((device) => device.id == deviceId);
    } catch (e) {
      return null;
    }
  }

  List<Device> getDevicesByRoom(String roomId) {
    return _devices.where((device) => device.roomId == roomId).toList();
  }

  List<Device> getDevicesByType(DeviceType type) {
    return _devices.where((device) => device.type == type).toList();
  }

  // Room Methods
  void setRooms(List<Room> rooms) {
    _rooms = rooms;
    notifyListeners();
  }

  void addRoom(Room room) {
    _rooms.add(room);
    notifyListeners();
  }

  void updateRoom(Room updatedRoom) {
    final index = _rooms.indexWhere((room) => room.id == updatedRoom.id);
    if (index != -1) {
      _rooms[index] = updatedRoom;
      notifyListeners();
    }
  }

  void removeRoom(String roomId) {
    _rooms.removeWhere((room) => room.id == roomId);
    notifyListeners();
  }

  Room? getRoomById(String roomId) {
    try {
      return _rooms.firstWhere((room) => room.id == roomId);
    } catch (e) {
      return null;
    }
  }

  // Routine Methods
  void setRoutines(List<Routine> routines) {
    _routines = routines;
    notifyListeners();
  }

  void addRoutine(Routine routine) {
    _routines.add(routine);
    notifyListeners();
  }

  void updateRoutine(Routine updatedRoutine) {
    final index = _routines.indexWhere((routine) => routine.id == updatedRoutine.id);
    if (index != -1) {
      _routines[index] = updatedRoutine;
      notifyListeners();
    }
  }

  void removeRoutine(String routineId) {
    _routines.removeWhere((routine) => routine.id == routineId);
    notifyListeners();
  }

  void toggleRoutine(String routineId) {
    final index = _routines.indexWhere((routine) => routine.id == routineId);
    if (index != -1) {
      _routines[index] = _routines[index].copyWith(
        isEnabled: !_routines[index].isEnabled,
      );
      notifyListeners();
    }
  }

  // Activity Methods
  void setActivities(List<Activity> activities) {
    _activities = activities;
    notifyListeners();
  }

  void addActivity(Activity activity) {
    _activities.insert(0, activity); // Add to beginning for chronological order
    notifyListeners();
  }

  void markActivityAsRead(String activityId) {
    final index = _activities.indexWhere((activity) => activity.id == activityId);
    if (index != -1) {
      _activities[index] = _activities[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllActivitiesAsRead() {
    _activities = _activities.map((activity) => activity.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void clearActivities() {
    _activities.clear();
    notifyListeners();
  }

  // Favorites Methods
  void toggleFavoriteDevice(String deviceId) {
    if (_favoriteDeviceIds.contains(deviceId)) {
      _favoriteDeviceIds.remove(deviceId);
    } else {
      _favoriteDeviceIds.add(deviceId);
    }
    notifyListeners();
  }

  void setFavoriteDevices(List<String> deviceIds) {
    _favoriteDeviceIds = deviceIds;
    notifyListeners();
  }

  bool isDeviceFavorite(String deviceId) {
    return _favoriteDeviceIds.contains(deviceId);
  }

  // Loading State Methods
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setDevicesLoading(bool loading) {
    _isDevicesLoading = loading;
    notifyListeners();
  }

  void setRoutinesLoading(bool loading) {
    _isRoutinesLoading = loading;
    notifyListeners();
  }

  void setActivitiesLoading(bool loading) {
    _isActivitiesLoading = loading;
    notifyListeners();
  }

  // Error Handling
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Utility Methods
  void refresh() {
    // This would typically reload data from services
    notifyListeners();
  }

  void reset() {
    _devices.clear();
    _rooms.clear();
    _routines.clear();
    _activities.clear();
    _favoriteDeviceIds.clear();
    _currentTabIndex = 0;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}