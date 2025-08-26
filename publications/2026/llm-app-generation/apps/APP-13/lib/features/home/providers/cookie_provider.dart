import 'package:flutter/foundation.dart';
import '../../../shared/models/cookie.dart';

class CookieProvider extends ChangeNotifier {
  List<Cookie> _weeklyCookies = [];
  bool _isLoading = false;

  List<Cookie> get weeklyCookies => _weeklyCookies;
  bool get isLoading => _isLoading;

  void setWeeklyCookies(List<Cookie> cookies) {
    _weeklyCookies = cookies;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadWeeklyCookies() async {
    setLoading(true);
    // TODO: Implement API call
    // For now, use mock data
    await Future.delayed(const Duration(seconds: 1));
    setLoading(false);
  }
}