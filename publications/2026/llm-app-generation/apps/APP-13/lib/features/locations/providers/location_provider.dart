import 'package:flutter/foundation.dart';
import '../../../shared/models/store.dart';

class LocationProvider extends ChangeNotifier {
  List<Store> _stores = [];
  Store? _selectedStore;
  bool _isLoading = false;

  List<Store> get stores => _stores;
  Store? get selectedStore => _selectedStore;
  bool get isLoading => _isLoading;

  void setStores(List<Store> stores) {
    _stores = stores;
    notifyListeners();
  }

  void setSelectedStore(Store? store) {
    _selectedStore = store;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadNearbyStores() async {
    setLoading(true);
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    setLoading(false);
  }
}