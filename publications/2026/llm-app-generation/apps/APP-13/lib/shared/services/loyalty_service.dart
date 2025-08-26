import 'package:flutter/foundation.dart';
import '../models/loyalty.dart';

class LoyaltyService extends ChangeNotifier {
  LoyaltyAccount? _loyaltyAccount;

  LoyaltyAccount? get loyaltyAccount => _loyaltyAccount;

  void setLoyaltyAccount(LoyaltyAccount account) {
    _loyaltyAccount = account;
    notifyListeners();
  }

  void addPoints(int points) {
    if (_loyaltyAccount != null) {
      _loyaltyAccount = _loyaltyAccount!.copyWith(
        loyaltyCrumbs: _loyaltyAccount!.loyaltyCrumbs + points,
        totalPointsEarned: _loyaltyAccount!.totalPointsEarned + points,
      );
      notifyListeners();
    }
  }

  void redeemCrumblCash() {
    if (_loyaltyAccount != null && _loyaltyAccount!.canRedeemCrumblCash) {
      _loyaltyAccount = _loyaltyAccount!.copyWith(
        loyaltyCrumbs: _loyaltyAccount!.loyaltyCrumbs - 100,
        crumblCash: _loyaltyAccount!.crumblCash + 10.0,
      );
      notifyListeners();
    }
  }
}