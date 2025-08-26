class AppConstants {
  // App Information
  static const String appName = 'Nubank';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.nubank.com.br';
  static const String apiVersion = 'v1';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String pinCodeKey = 'pin_code';
  static const String streetModeKey = 'street_mode';
  
  // Transaction Limits
  static const double pixDailyLimit = 20000.0;
  static const double pixNightlyLimit = 1000.0;
  static const double transferDailyLimit = 50000.0;
  static const double billPaymentDailyLimit = 100000.0;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Credit Card Constants
  static const int creditCardNumberLength = 16;
  static const int creditCardCvvLength = 3;
  static const int creditCardExpiryLength = 4;
  
  // Pix Constants
  static const List<String> pixKeyTypes = [
    'CPF',
    'E-mail',
    'Telefone',
    'Chave aleatória',
  ];
  
  // Categories
  static const List<String> transactionCategories = [
    'Alimentação',
    'Transporte',
    'Saúde',
    'Educação',
    'Lazer',
    'Compras',
    'Casa',
    'Outros',
  ];
  
  static const List<String> caixinhaCategories = [
    'Emergência',
    'Férias',
    'Casa',
    'Carro',
    'Educação',
    'Saúde',
    'Geral',
  ];
  
  static const List<String> shoppingCategories = [
    'Eletrônicos',
    'Moda',
    'Casa e Jardim',
    'Esportes',
    'Livros',
    'Beleza',
    'Alimentação',
    'Viagem',
    'Outros',
  ];
  
  // Error Messages
  static const String genericErrorMessage = 'Algo deu errado. Tente novamente.';
  static const String networkErrorMessage = 'Verifique sua conexão com a internet.';
  static const String authErrorMessage = 'Sessão expirada. Faça login novamente.';
  static const String insufficientFundsMessage = 'Saldo insuficiente.';
  static const String invalidPinMessage = 'Senha incorreta.';
  static const String biometricErrorMessage = 'Falha na autenticação biométrica.';
  
  // Success Messages
  static const String pixSentSuccessMessage = 'Pix enviado com sucesso!';
  static const String billPaidSuccessMessage = 'Conta paga com sucesso!';
  static const String cardBlockedSuccessMessage = 'Cartão bloqueado com sucesso!';
  static const String cardUnblockedSuccessMessage = 'Cartão desbloqueado com sucesso!';
  
  // Validation
  static const String cpfPattern = r'^\d{3}\.\d{3}\.\d{3}-\d{2}$';
  static const String phonePattern = r'^\(\d{2}\) \d{4,5}-\d{4}$';
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  
  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';
  static const String monthYearFormat = 'MM/yyyy';
  
  // Currency
  static const String currencySymbol = 'R\$';
  static const String currencyCode = 'BRL';
  
  // Deep Links
  static const String pixDeepLink = 'nubank://pix';
  static const String creditCardDeepLink = 'nubank://credit-card';
  static const String accountDeepLink = 'nubank://account';
  static const String shoppingDeepLink = 'nubank://shopping';
  
  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enableStreetMode = true;
  static const bool enableVirtualCard = true;
  static const bool enableCaixinhas = true;
  static const bool enableShopping = true;
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration biometricTimeout = Duration(seconds: 60);
  static const Duration pinTimeout = Duration(minutes: 5);
}

class AppImages {
  static const String _basePath = 'assets/images/';
  
  // Logos
  static const String nubankLogo = '${_basePath}nubank_logo.png';
  static const String nubankLogoWhite = '${_basePath}nubank_logo_white.png';
  
  // Illustrations
  static const String creditCardIllustration = '${_basePath}credit_card_illustration.png';
  static const String pixIllustration = '${_basePath}pix_illustration.png';
  static const String shoppingIllustration = '${_basePath}shopping_illustration.png';
  static const String caixinhaIllustration = '${_basePath}caixinha_illustration.png';
  
  // Placeholders
  static const String userPlaceholder = '${_basePath}user_placeholder.png';
  static const String merchantPlaceholder = '${_basePath}merchant_placeholder.png';
}

class AppIcons {
  static const String _basePath = 'assets/icons/';
  
  // Navigation
  static const String homeIcon = '${_basePath}home.svg';
  static const String planningIcon = '${_basePath}planning.svg';
  static const String shoppingIcon = '${_basePath}shopping.svg';
  
  // Actions
  static const String pixIcon = '${_basePath}pix.svg';
  static const String payIcon = '${_basePath}pay.svg';
  static const String transferIcon = '${_basePath}transfer.svg';
  static const String depositIcon = '${_basePath}deposit.svg';
  
  // Cards
  static const String creditCardIcon = '${_basePath}credit_card.svg';
  static const String virtualCardIcon = '${_basePath}virtual_card.svg';
  
  // Security
  static const String lockIcon = '${_basePath}lock.svg';
  static const String unlockIcon = '${_basePath}unlock.svg';
  static const String biometricIcon = '${_basePath}biometric.svg';
  
  // Categories
  static const String emergencyIcon = '${_basePath}emergency.svg';
  static const String vacationIcon = '${_basePath}vacation.svg';
  static const String houseIcon = '${_basePath}house.svg';
  static const String carIcon = '${_basePath}car.svg';
  static const String educationIcon = '${_basePath}education.svg';
  static const String healthIcon = '${_basePath}health.svg';
}