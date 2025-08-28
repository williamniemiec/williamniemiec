import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../main_navigation.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => NavigationHelper.showLogoutDialog(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Header
                _buildProfileHeader(user),
                
                const SizedBox(height: 24),
                
                // Personal Information Section
                _buildPersonalInfoSection(user),
                
                const SizedBox(height: 24),
                
                // Health Information Section
                _buildHealthInfoSection(user),
                
                const SizedBox(height: 24),
                
                // Donor Status Section
                _buildDonorStatusSection(user, authProvider),
                
                const SizedBox(height: 24),
                
                // App Settings Section
                _buildAppSettingsSection(),
                
                const SizedBox(height: 24),
                
                // Support Section
                _buildSupportSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: AppColors.textOnPrimary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // User Name
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 4),
          
          // CPF
          Text(
            'CPF: ${_formatCPF(user.cpf)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textOnPrimary.withOpacity(0.9),
            ),
          ),
          
          const SizedBox(height: 2),
          
          // CNS
          Text(
            'CNS: ${user.cns}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textOnPrimary.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(user) {
    return _buildSection(
      title: 'Informações Pessoais',
      icon: Icons.person_outline,
      children: [
        _buildInfoTile(
          icon: Icons.email_outlined,
          title: 'E-mail',
          value: user.email,
        ),
        _buildInfoTile(
          icon: Icons.phone_outlined,
          title: 'Telefone',
          value: user.phone,
        ),
        _buildInfoTile(
          icon: Icons.cake_outlined,
          title: 'Data de Nascimento',
          value: _formatDate(user.dateOfBirth),
        ),
        _buildInfoTile(
          icon: Icons.wc_outlined,
          title: 'Gênero',
          value: user.gender,
        ),
        _buildInfoTile(
          icon: Icons.location_on_outlined,
          title: 'Endereço',
          value: user.address.fullAddress,
          isMultiline: true,
        ),
      ],
    );
  }

  Widget _buildHealthInfoSection(user) {
    return _buildSection(
      title: 'Informações de Saúde',
      icon: Icons.health_and_safety_outlined,
      children: [
        _buildActionTile(
          icon: Icons.credit_card,
          title: 'Cartão Nacional de Saúde',
          subtitle: 'CNS: ${user.cns}',
          onTap: () => NavigationHelper.navigateToCNSCard(context),
        ),
        _buildActionTile(
          icon: Icons.vaccines,
          title: 'Histórico de Vacinas',
          subtitle: 'Consulte suas vacinas e certificados',
          onTap: () => NavigationHelper.navigateToVaccines(context),
        ),
        _buildActionTile(
          icon: Icons.science,
          title: 'Resultados de Exames',
          subtitle: 'Veja seus exames laboratoriais',
          onTap: () => NavigationHelper.navigateToExams(context),
        ),
        _buildActionTile(
          icon: Icons.medication,
          title: 'Medicamentos',
          subtitle: 'Histórico da Farmácia Popular',
          onTap: () => NavigationHelper.navigateToMedications(context),
        ),
      ],
    );
  }

  Widget _buildDonorStatusSection(user, AuthProvider authProvider) {
    return _buildSection(
      title: 'Status de Doador',
      icon: Icons.favorite_outline,
      children: [
        _buildSwitchTile(
          icon: Icons.favorite,
          title: 'Doador de Órgãos',
          subtitle: user.isOrganDonor 
              ? 'Você é um doador de órgãos registrado'
              : 'Registre-se como doador de órgãos',
          value: user.isOrganDonor,
          onChanged: (value) => _updateDonorStatus(authProvider, isOrganDonor: value),
        ),
        _buildSwitchTile(
          icon: Icons.bloodtype,
          title: 'Doador de Sangue',
          subtitle: user.isBloodDonor 
              ? 'Você é um doador de sangue registrado'
              : 'Registre-se como doador de sangue',
          value: user.isBloodDonor,
          onChanged: (value) => _updateDonorStatus(authProvider, isBloodDonor: value),
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection() {
    return _buildSection(
      title: 'Configurações do App',
      icon: Icons.settings_outlined,
      children: [
        _buildActionTile(
          icon: Icons.notifications_outlined,
          title: 'Notificações',
          subtitle: 'Gerencie suas notificações',
          onTap: () => NavigationHelper.showComingSoonDialog(context, 'Configurações de Notificação'),
        ),
        _buildActionTile(
          icon: Icons.security_outlined,
          title: 'Privacidade e Segurança',
          subtitle: 'Configurações de privacidade',
          onTap: () => NavigationHelper.showComingSoonDialog(context, 'Configurações de Privacidade'),
        ),
        _buildActionTile(
          icon: Icons.language_outlined,
          title: 'Idioma',
          subtitle: 'Português (Brasil)',
          onTap: () => NavigationHelper.showComingSoonDialog(context, 'Seleção de Idioma'),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSection(
      title: 'Suporte',
      icon: Icons.help_outline,
      children: [
        _buildActionTile(
          icon: Icons.help_outline,
          title: 'Central de Ajuda',
          subtitle: 'Perguntas frequentes e tutoriais',
          onTap: () => NavigationHelper.showComingSoonDialog(context, 'Central de Ajuda'),
        ),
        _buildActionTile(
          icon: Icons.contact_support_outlined,
          title: 'Fale Conosco',
          subtitle: 'Entre em contato com o suporte',
          onTap: () => NavigationHelper.showComingSoonDialog(context, 'Fale Conosco'),
        ),
        _buildActionTile(
          icon: Icons.info_outline,
          title: 'Sobre o App',
          subtitle: 'Versão ${AppConstants.appVersion}',
          onTap: () => _showAboutDialog(),
        ),
        _buildActionTile(
          icon: Icons.logout,
          title: 'Sair do App',
          subtitle: 'Fazer logout da sua conta',
          onTap: () => NavigationHelper.showLogoutDialog(context),
          textColor: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Section Content
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: 12,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: textColor ?? AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor ?? AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: value ? AppColors.donorColor : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.donorColor,
          ),
        ],
      ),
    );
  }

  void _updateDonorStatus(AuthProvider authProvider, {bool? isOrganDonor, bool? isBloodDonor}) async {
    final success = await authProvider.updateDonorStatus(
      isOrganDonor: isOrganDonor,
      isBloodDonor: isBloodDonor,
    );

    if (success && mounted) {
      final donorType = isOrganDonor != null ? 'órgãos' : 'sangue';
      final action = (isOrganDonor ?? isBloodDonor!) ? 'registrado' : 'removido';
      
      NavigationHelper.showSuccessSnackBar(
        context,
        'Status de doador de $donorType $action com sucesso!',
      );
    } else if (mounted) {
      NavigationHelper.showErrorSnackBar(
        context,
        'Erro ao atualizar status de doador. Tente novamente.',
      );
    }
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.health_and_safety,
          color: AppColors.textOnPrimary,
          size: 32,
        ),
      ),
      children: [
        Text(AppConstants.appDescription),
        const SizedBox(height: 16),
        const Text(
          'Desenvolvido pelo Ministério da Saúde em parceria com o DATASUS.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  String _formatCPF(String cpf) {
    if (cpf.length == 11) {
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
    }
    return cpf;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}