import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  
                  // App Logo and Title
                  _buildHeader(),
                  
                  const SizedBox(height: 60),
                  
                  // Welcome Message
                  _buildWelcomeMessage(),
                  
                  const SizedBox(height: 40),
                  
                  // Gov.br Login Button
                  _buildGovBrLoginButton(authProvider),
                  
                  const SizedBox(height: 20),
                  
                  // Demo Login Button (for testing)
                  _buildDemoLoginButton(authProvider),
                  
                  const SizedBox(height: 40),
                  
                  // Information Text
                  _buildInformationText(),
                  
                  const SizedBox(height: 20),
                  
                  // Loading Indicator
                  if (authProvider.isLoading) _buildLoadingIndicator(),
                  
                  // Error Message
                  if (authProvider.errorMessage != null) 
                    _buildErrorMessage(authProvider.errorMessage!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // SUS Logo placeholder
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.health_and_safety,
            size: 60,
            color: AppColors.textOnPrimary,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // App Title
        Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // App Subtitle
        Text(
          AppConstants.appDescription,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.security,
            size: 48,
            color: AppColors.secondary,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Acesso Seguro',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Para acessar seus dados de saúde, faça login com sua conta Gov.br. '
            'Seus dados estão protegidos e seguros.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGovBrLoginButton(AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: authProvider.isLoading ? null : () => _handleGovBrLogin(authProvider),
        icon: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.textOnPrimary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.account_balance,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        label: Text(
          'Entrar com Gov.br',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoLoginButton(AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: authProvider.isLoading ? null : () => _handleDemoLogin(authProvider),
        icon: const Icon(Icons.play_arrow, size: 20),
        label: const Text('Demo - Login Simulado'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondary,
          side: const BorderSide(color: AppColors.secondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildInformationText() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.info,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Informações importantes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '• Você precisa ter uma conta Gov.br para acessar o app\n'
            '• Seus dados são protegidos pela Lei Geral de Proteção de Dados\n'
            '• O acesso é feito de forma segura através do portal oficial do governo',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Conectando com Gov.br...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGovBrLogin(AuthProvider authProvider) async {
    final success = await authProvider.loginWithGovBr();
    if (success && mounted) {
      // The actual authentication will be completed when the user returns from Gov.br
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Redirecionando para Gov.br...'),
          backgroundColor: AppColors.info,
        ),
      );
    }
  }

  Future<void> _handleDemoLogin(AuthProvider authProvider) async {
    final success = await authProvider.simulateLogin();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Navigate to home screen
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}