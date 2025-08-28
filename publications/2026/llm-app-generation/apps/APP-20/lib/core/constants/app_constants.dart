class AppConstants {
  // App Information
  static const String appName = 'Conecte SUS';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Plataforma digital oficial do Sistema Único de Saúde';
  
  // Gov.br Integration
  static const String govBrBaseUrl = 'https://sso.acesso.gov.br';
  static const String govBrClientId = 'conecte_sus_app';
  static const String govBrRedirectUri = 'conectesus://auth/callback';
  static const String govBrScope = 'openid email profile';
  
  // API Endpoints
  static const String apiBaseUrl = 'https://api.conectesus.saude.gov.br/v1';
  static const String cnsEndpoint = '/cns';
  static const String vaccinationEndpoint = '/vaccination';
  static const String examsEndpoint = '/exams';
  static const String medicationsEndpoint = '/medications';
  static const String appointmentsEndpoint = '/appointments';
  static const String messagesEndpoint = '/messages';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  
  // Navigation
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String vaccinesRoute = '/vaccines';
  static const String actionsRoute = '/actions';
  static const String messagesRoute = '/messages';
  static const String profileRoute = '/profile';
  static const String cnsCardRoute = '/cns-card';
  static const String vaccineCertificateRoute = '/vaccine-certificate';
  static const String examsRoute = '/exams';
  static const String medicationsRoute = '/medications';
  static const String appointmentsRoute = '/appointments';
  
  // Vaccination Certificate Languages
  static const List<String> certificateLanguages = ['pt', 'en', 'es'];
  static const Map<String, String> languageNames = {
    'pt': 'Português',
    'en': 'English',
    'es': 'Español',
  };
  
  // Error Messages
  static const String networkErrorMessage = 'Erro de conexão. Verifique sua internet.';
  static const String authErrorMessage = 'Erro de autenticação. Tente novamente.';
  static const String genericErrorMessage = 'Ocorreu um erro. Tente novamente.';
  static const String noDataMessage = 'Nenhum dado encontrado.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Login realizado com sucesso!';
  static const String certificateGeneratedMessage = 'Certificado gerado com sucesso!';
  static const String donorRegisteredMessage = 'Registro de doador realizado com sucesso!';
}