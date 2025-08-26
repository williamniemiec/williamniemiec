import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'PayPal';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your digital wallet and financial hub';

  // API Configuration
  static const String baseUrl = 'https://api.paypal.com/v1';
  static const String sandboxUrl = 'https://api.sandbox.paypal.com/v1';
  static const Duration requestTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String darkModeKey = 'dark_mode';
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String languageKey = 'language';
  static const String currencyKey = 'currency';

  // Transaction Limits
  static const double maxSendAmount = 10000.0;
  static const double minSendAmount = 1.0;
  static const double maxRequestAmount = 10000.0;
  static const double minRequestAmount = 1.0;
  static const double dailyTransactionLimit = 25000.0;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  static const double cardElevation = 2.0;
  static const double modalElevation = 8.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Supported Currencies
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'CAD',
    'AUD',
    'JPY',
    'CHF',
    'SEK',
    'NOK',
    'DKK',
    'PLN',
    'CZK',
    'HUF',
    'ILS',
    'MXN',
    'BRL',
    'SGD',
    'HKD',
    'NZD',
    'TWD',
    'THB',
    'MYR',
    'PHP',
  ];

  // Supported Languages
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'it', 'name': 'Italiano'},
    {'code': 'pt', 'name': 'Português'},
    {'code': 'zh', 'name': '中文'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'ko', 'name': '한국어'},
    {'code': 'ar', 'name': 'العربية'},
  ];

  // QR Code Configuration
  static const double qrCodeSize = 200.0;
  static const int qrCodeVersion = 4;
  static const String qrCodePrefix = 'paypal://';

  // Biometric Authentication
  static const String biometricReason = 'Please authenticate to access your PayPal account';
  static const Duration biometricTimeout = Duration(seconds: 60);

  // Error Messages
  static const String networkErrorMessage = 'Network connection error. Please check your internet connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String authenticationErrorMessage = 'Authentication failed. Please log in again.';
  static const String insufficientFundsMessage = 'Insufficient funds. Please add money to your account or use a different payment method.';
  static const String transactionLimitMessage = 'Transaction limit exceeded. Please try a smaller amount.';
  static const String invalidRecipientMessage = 'Invalid recipient. Please check the email or phone number.';

  // Success Messages
  static const String transactionSuccessMessage = 'Transaction completed successfully!';
  static const String paymentMethodAddedMessage = 'Payment method added successfully!';
  static const String dealSavedMessage = 'Deal saved successfully!';
  static const String profileUpdatedMessage = 'Profile updated successfully!';

  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enableQRCodePayments = true;
  static const bool enableDeals = true;
  static const bool enableBillPay = true;
  static const bool enablePayIn4 = true;
  static const bool enableSavingsAccount = true;
  static const bool enableDebitCard = true;

  // Deal Categories
  static const List<String> dealCategories = [
    'All',
    'Food & Dining',
    'Shopping',
    'Travel',
    'Entertainment',
    'Gas & Automotive',
    'Health & Beauty',
    'Home & Garden',
    'Electronics',
    'Sports & Outdoors',
    'Books & Education',
    'Services',
  ];

  // Transaction Categories
  static const List<String> transactionCategories = [
    'All',
    'Sent',
    'Received',
    'Purchases',
    'Refunds',
    'Bill Payments',
    'Cash Back',
    'Deposits',
    'Withdrawals',
  ];

  // Contact Methods
  static const List<String> contactMethods = [
    'Email',
    'Phone',
    'Username',
  ];

  // Payment Method Types
  static const List<String> paymentMethodTypes = [
    'Bank Account',
    'Credit Card',
    'Debit Card',
    'PayPal Balance',
    'PayPal Credit',
  ];

  // Validation Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  static const String amountPattern = r'^\d+(\.\d{1,2})?$';

  // Image Assets
  static const String logoPath = 'assets/images/paypal_logo.png';
  static const String placeholderAvatarPath = 'assets/images/placeholder_avatar.png';
  static const String emptyStatePath = 'assets/images/empty_state.png';
  static const String successAnimationPath = 'assets/animations/success.json';
  static const String loadingAnimationPath = 'assets/animations/loading.json';
  static const String errorAnimationPath = 'assets/animations/error.json';

  // Icon Assets
  static const String homeIconPath = 'assets/icons/home.svg';
  static const String paymentsIconPath = 'assets/icons/payments.svg';
  static const String walletIconPath = 'assets/icons/wallet.svg';
  static const String dealsIconPath = 'assets/icons/deals.svg';
  static const String qrCodeIconPath = 'assets/icons/qr_code.svg';
  static const String sendIconPath = 'assets/icons/send.svg';
  static const String requestIconPath = 'assets/icons/request.svg';
  static const String scanIconPath = 'assets/icons/scan.svg';

  // URLs
  static const String termsOfServiceUrl = 'https://www.paypal.com/us/webapps/mpp/ua/useragreement-full';
  static const String privacyPolicyUrl = 'https://www.paypal.com/us/webapps/mpp/ua/privacy-full';
  static const String supportUrl = 'https://www.paypal.com/us/smarthelp/home';
  static const String aboutUrl = 'https://www.paypal.com/us/webapps/mpp/about';

  // Social Media
  static const String facebookUrl = 'https://www.facebook.com/PayPal';
  static const String twitterUrl = 'https://twitter.com/PayPal';
  static const String instagramUrl = 'https://www.instagram.com/paypal';
  static const String linkedinUrl = 'https://www.linkedin.com/company/paypal';

  // App Store URLs
  static const String appStoreUrl = 'https://apps.apple.com/app/paypal-mobile-cash/id283646709';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.paypal.android.p2pmobile';
}