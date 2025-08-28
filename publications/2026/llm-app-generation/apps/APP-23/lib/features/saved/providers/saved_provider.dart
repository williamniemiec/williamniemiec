import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../shared/models/models.dart';
import '../../../core/constants/app_constants.dart';

class SavedProvider extends ChangeNotifier {
  List<SavedPlacesList> _savedLists = [];
  List<SavedPlace> _allSavedPlaces = [];
  SavedPlacesList? _selectedList;
  bool _isLoading = false;

  // Getters
  List<SavedPlacesList> get savedLists => _savedLists;
  List<SavedPlace> get allSavedPlaces => _allSavedPlaces;
  SavedPlacesList? get selectedList => _selectedList;
  bool get isLoading => _isLoading;

  /// Initialize saved provider
  Future<void> initialize() async {
    _setLoading(true);
    
    try {
      await _loadSavedData();
      await _createDefaultLists();
    } catch (e) {
      print('Error initializing saved provider: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new saved places list
  Future<void> createList(String name, {String? description, String iconName = 'bookmark'}) async {
    final newList = SavedPlacesList(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      createdAt: DateTime.now(),
      iconName: iconName,
    );

    _savedLists.add(newList);
    await _saveSavedData();
    notifyListeners();
  }

  /// Delete a saved places list
  Future<void> deleteList(String listId) async {
    _savedLists.removeWhere((list) => list.id == listId);
    _allSavedPlaces.removeWhere((place) => place.listName == listId);
    
    if (_selectedList?.id == listId) {
      _selectedList = null;
    }
    
    await _saveSavedData();
    notifyListeners();
  }

  /// Rename a saved places list
  Future<void> renameList(String listId, String newName) async {
    final listIndex = _savedLists.indexWhere((list) => list.id == listId);
    if (listIndex != -1) {
      _savedLists[listIndex] = _savedLists[listIndex].copyWith(name: newName);
      await _saveSavedData();
      notifyListeners();
    }
  }

  /// Save a place to a list
  Future<void> savePlace(Place place, String listName) async {
    final savedPlace = SavedPlace(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      place: place,
      listName: listName,
      savedAt: DateTime.now(),
    );

    _allSavedPlaces.add(savedPlace);
    
    // Update the list to include this place
    final listIndex = _savedLists.indexWhere((list) => list.name == listName);
    if (listIndex != -1) {
      final updatedPlaces = [..._savedLists[listIndex].places, savedPlace];
      _savedLists[listIndex] = _savedLists[listIndex].copyWith(places: updatedPlaces);
    }

    await _saveSavedData();
    notifyListeners();
  }

  /// Remove a place from saved places
  Future<void> removePlace(String placeId) async {
    final savedPlace = _allSavedPlaces.firstWhere((place) => place.id == placeId);
    _allSavedPlaces.removeWhere((place) => place.id == placeId);
    
    // Update the list to remove this place
    final listIndex = _savedLists.indexWhere((list) => list.name == savedPlace.listName);
    if (listIndex != -1) {
      final updatedPlaces = _savedLists[listIndex].places.where((place) => place.id != placeId).toList();
      _savedLists[listIndex] = _savedLists[listIndex].copyWith(places: updatedPlaces);
    }

    await _saveSavedData();
    notifyListeners();
  }

  /// Move a place to a different list
  Future<void> movePlace(String placeId, String newListName) async {
    final placeIndex = _allSavedPlaces.indexWhere((place) => place.id == placeId);
    if (placeIndex != -1) {
      final oldListName = _allSavedPlaces[placeIndex].listName;
      _allSavedPlaces[placeIndex] = _allSavedPlaces[placeIndex].copyWith(listName: newListName);
      
      // Remove from old list
      final oldListIndex = _savedLists.indexWhere((list) => list.name == oldListName);
      if (oldListIndex != -1) {
        final updatedOldPlaces = _savedLists[oldListIndex].places.where((place) => place.id != placeId).toList();
        _savedLists[oldListIndex] = _savedLists[oldListIndex].copyWith(places: updatedOldPlaces);
      }
      
      // Add to new list
      final newListIndex = _savedLists.indexWhere((list) => list.name == newListName);
      if (newListIndex != -1) {
        final updatedNewPlaces = [..._savedLists[newListIndex].places, _allSavedPlaces[placeIndex]];
        _savedLists[newListIndex] = _savedLists[newListIndex].copyWith(places: updatedNewPlaces);
      }

      await _saveSavedData();
      notifyListeners();
    }
  }

  /// Toggle favorite status of a place
  Future<void> toggleFavorite(String placeId) async {
    final placeIndex = _allSavedPlaces.indexWhere((place) => place.id == placeId);
    if (placeIndex != -1) {
      _allSavedPlaces[placeIndex] = _allSavedPlaces[placeIndex].copyWith(
        isFavorite: !_allSavedPlaces[placeIndex].isFavorite,
      );
      
      // Update in the corresponding list
      final listIndex = _savedLists.indexWhere((list) => list.name == _allSavedPlaces[placeIndex].listName);
      if (listIndex != -1) {
        final updatedPlaces = _savedLists[listIndex].places.map((place) {
          if (place.id == placeId) {
            return place.copyWith(isFavorite: !place.isFavorite);
          }
          return place;
        }).toList();
        _savedLists[listIndex] = _savedLists[listIndex].copyWith(places: updatedPlaces);
      }

      await _saveSavedData();
      notifyListeners();
    }
  }

  /// Add notes to a saved place
  Future<void> addNotes(String placeId, String notes) async {
    final placeIndex = _allSavedPlaces.indexWhere((place) => place.id == placeId);
    if (placeIndex != -1) {
      _allSavedPlaces[placeIndex] = _allSavedPlaces[placeIndex].copyWith(notes: notes);
      
      // Update in the corresponding list
      final listIndex = _savedLists.indexWhere((list) => list.name == _allSavedPlaces[placeIndex].listName);
      if (listIndex != -1) {
        final updatedPlaces = _savedLists[listIndex].places.map((place) {
          if (place.id == placeId) {
            return place.copyWith(notes: notes);
          }
          return place;
        }).toList();
        _savedLists[listIndex] = _savedLists[listIndex].copyWith(places: updatedPlaces);
      }

      await _saveSavedData();
      notifyListeners();
    }
  }

  /// Get places from a specific list
  List<SavedPlace> getPlacesFromList(String listName) {
    return _allSavedPlaces.where((place) => place.listName == listName).toList();
  }

  /// Get favorite places
  List<SavedPlace> getFavoritePlaces() {
    return _allSavedPlaces.where((place) => place.isFavorite).toList();
  }

  /// Check if a place is saved
  bool isPlaceSaved(String placeId) {
    return _allSavedPlaces.any((place) => place.place.id == placeId);
  }

  /// Get saved place by place ID
  SavedPlace? getSavedPlace(String placeId) {
    try {
      return _allSavedPlaces.firstWhere((place) => place.place.id == placeId);
    } catch (e) {
      return null;
    }
  }

  /// Select a list
  void selectList(SavedPlacesList list) {
    _selectedList = list;
    notifyListeners();
  }

  /// Clear selected list
  void clearSelectedList() {
    _selectedList = null;
    notifyListeners();
  }

  /// Search saved places
  List<SavedPlace> searchSavedPlaces(String query) {
    if (query.trim().isEmpty) return _allSavedPlaces;
    
    final lowercaseQuery = query.toLowerCase();
    return _allSavedPlaces.where((place) {
      return place.place.name.toLowerCase().contains(lowercaseQuery) ||
             place.place.address.toLowerCase().contains(lowercaseQuery) ||
             (place.notes?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  /// Create default lists if they don't exist
  Future<void> _createDefaultLists() async {
    if (_savedLists.isEmpty) {
      final defaultLists = [
        SavedPlacesList(
          id: 'favorites',
          name: 'Favorites',
          description: 'Your favorite places',
          createdAt: DateTime.now(),
          iconName: 'favorite',
          isDefault: true,
        ),
        SavedPlacesList(
          id: 'want_to_go',
          name: 'Want to go',
          description: 'Places you want to visit',
          createdAt: DateTime.now(),
          iconName: 'flag',
          isDefault: true,
        ),
      ];

      _savedLists.addAll(defaultLists);
      await _saveSavedData();
    }
  }

  /// Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load saved lists
      final listsJson = prefs.getString(AppConstants.keySavedPlaces);
      if (listsJson != null) {
        final listsData = json.decode(listsJson) as List;
        _savedLists = listsData.map((data) => SavedPlacesList.fromJson(data)).toList();
      }
      
      // Flatten all places from all lists
      _allSavedPlaces = [];
      for (final list in _savedLists) {
        _allSavedPlaces.addAll(list.places);
      }
    } catch (e) {
      print('Error loading saved data: $e');
    }
  }

  /// Save data to SharedPreferences
  Future<void> _saveSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save lists
      final listsJson = json.encode(_savedLists.map((list) => list.toJson()).toList());
      await prefs.setString(AppConstants.keySavedPlaces, listsJson);
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}