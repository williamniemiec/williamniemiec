class AppConstants {
  // App Information
  static const String appName = 'Betano';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.betano.com.br';
  static const String apiVersion = 'v1';
  
  // Brazilian Market Specific
  static const String currency = 'BRL';
  static const String currencySymbol = 'R\$';
  static const String locale = 'pt_BR';
  
  // Betting Limits
  static const double minBetAmount = 1.0;
  static const double maxBetAmount = 10000.0;
  static const double minDepositAmount = 10.0;
  static const double maxDepositAmount = 50000.0;
  
  // Sports Categories
  static const List<String> popularSports = [
    'football',
    'basketball',
    'tennis',
    'volleyball',
    'mma',
    'futsal',
    'handball',
  ];
  
  // Casino Game Categories
  static const List<String> casinoCategories = [
    'slots',
    'live_casino',
    'table_games',
    'crash_games',
    'jackpots',
    'new_games',
    'popular',
  ];
  
  // Payment Methods (Brazilian Market)
  static const List<String> paymentMethods = [
    'pix',
    'bank_transfer',
    'credit_card',
    'debit_card',
    'boleto',
  ];
  
  // Responsible Gaming Limits
  static const Map<String, dynamic> responsibleGamingDefaults = {
    'daily_deposit_limit': 1000.0,
    'weekly_deposit_limit': 5000.0,
    'monthly_deposit_limit': 20000.0,
    'session_time_limit': 240, // minutes
    'loss_limit': 500.0,
  };
  
  // Navigation Routes
  static const String homeRoute = '/';
  static const String sportsRoute = '/sports';
  static const String liveBettingRoute = '/live';
  static const String casinoRoute = '/casino';
  static const String betSlipRoute = '/bet-slip';
  static const String promotionsRoute = '/promotions';
  static const String accountRoute = '/account';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String kycRoute = '/kyc';
  static const String depositRoute = '/deposit';
  static const String withdrawRoute = '/withdraw';
  static const String historyRoute = '/history';
  static const String responsibleGamingRoute = '/responsible-gaming';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String betSlipKey = 'bet_slip';
  static const String favoriteSportsKey = 'favorite_sports';
  static const String responsibleGamingLimitsKey = 'responsible_gaming_limits';
  
  // Notification Types
  static const String matchStartNotification = 'match_start';
  static const String goalNotification = 'goal';
  static const String betSettlementNotification = 'bet_settlement';
  static const String promotionNotification = 'promotion';
  static const String depositNotification = 'deposit';
  static const String withdrawalNotification = 'withdrawal';
  
  // Bet Types
  static const List<String> betTypes = [
    'single',
    'multiple',
    'system',
  ];
  
  // Live Streaming Quality
  static const List<String> streamingQualities = [
    'auto',
    'high',
    'medium',
    'low',
  ];
  
  // KYC Document Types
  static const List<String> kycDocumentTypes = [
    'cpf',
    'rg',
    'cnh',
    'passport',
    'proof_of_address',
  ];
  
  // Error Messages
  static const String networkErrorMessage = 'Erro de conexão. Verifique sua internet.';
  static const String serverErrorMessage = 'Erro no servidor. Tente novamente.';
  static const String invalidCredentialsMessage = 'Credenciais inválidas.';
  static const String insufficientBalanceMessage = 'Saldo insuficiente.';
  static const String betLimitExceededMessage = 'Limite de aposta excedido.';
  static const String kycRequiredMessage = 'Verificação de identidade necessária.';
  
  // Success Messages
  static const String betPlacedSuccessMessage = 'Aposta realizada com sucesso!';
  static const String depositSuccessMessage = 'Depósito realizado com sucesso!';
  static const String withdrawalRequestedMessage = 'Saque solicitado com sucesso!';
  static const String kycSubmittedMessage = 'Documentos enviados para análise.';
  
  // Regex Patterns
  static const String cpfPattern = r'^\d{3}\.\d{3}\.\d{3}-\d{2}$';
  static const String phonePattern = r'^\(\d{2}\)\s\d{4,5}-\d{4}$';
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration streamingTimeout = Duration(seconds: 10);
  
  // Cache Durations
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(minutes: 30);
  static const Duration longCacheDuration = Duration(hours: 24);
}