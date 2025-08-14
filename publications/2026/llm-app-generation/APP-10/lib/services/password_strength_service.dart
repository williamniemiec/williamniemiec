class PasswordStrengthService {
  static double calculateStrength(String password) {
    if (password.isEmpty) {
      return 0;
    }

    double score = 0;

    // Length score
    if (password.length >= 8) {
      score += 0.2;
    }
    if (password.length >= 12) {
      score += 0.2;
    }

    // Character type score
    if (RegExp(r'[a-z]').hasMatch(password)) {
      score += 0.2;
    }
    if (RegExp(r'[A-Z]').hasMatch(password)) {
      score += 0.2;
    }
    if (RegExp(r'[0-9]').hasMatch(password)) {
      score += 0.2;
    }
    if (RegExp(r'[^a-zA-Z0-9]').hasMatch(password)) {
      score += 0.2;
    }

    return score.clamp(0, 1);
  }
}