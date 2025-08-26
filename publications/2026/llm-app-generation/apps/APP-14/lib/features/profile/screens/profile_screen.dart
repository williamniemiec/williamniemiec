import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          if (user == null) {
            return _buildSignInPrompt(context);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // User Info Card
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppTheme.primaryRed.withOpacity(0.1),
                        backgroundImage: user.profileImage != null
                            ? NetworkImage(user.profileImage!)
                            : null,
                        child: user.profileImage == null
                            ? Icon(
                                Icons.person,
                                size: 32,
                                color: AppTheme.primaryRed,
                              )
                            : null,
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // User Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textGrey,
                              ),
                            ),
                            if (user.phone != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                user.phone!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textGrey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      // Edit Button
                      IconButton(
                        onPressed: () {
                          // Navigate to edit profile
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Clube iFood Card
                if (!user.isClubeMember)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: _buildClubeCard(context),
                  )
                else
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: _buildClubeActiveCard(context, user.clubeExpiryDate),
                  ),

                // Menu Options
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.location_on,
                        title: 'Endereços',
                        subtitle: '${user.addresses.length} endereços salvos',
                        onTap: () {
                          // Navigate to addresses
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.payment,
                        title: 'Formas de pagamento',
                        subtitle: '${user.paymentMethods.length} métodos salvos',
                        onTap: () {
                          // Navigate to payment methods
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.local_offer,
                        title: 'Cupons',
                        subtitle: 'Seus cupons de desconto',
                        onTap: () {
                          // Navigate to coupons
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.favorite,
                        title: 'Favoritos',
                        subtitle: 'Restaurantes favoritos',
                        onTap: () {
                          // Navigate to favorites
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Support & Info
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.help,
                        title: 'Ajuda',
                        subtitle: 'Central de ajuda e suporte',
                        onTap: () {
                          // Navigate to help
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.info,
                        title: 'Sobre o iFood',
                        subtitle: 'Informações do aplicativo',
                        onTap: () {
                          // Navigate to about
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.privacy_tip,
                        title: 'Privacidade',
                        subtitle: 'Política de privacidade',
                        onTap: () {
                          // Navigate to privacy
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Sign Out
                Container(
                  color: Colors.white,
                  child: _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Sair',
                    subtitle: 'Fazer logout da conta',
                    onTap: () => _showSignOutDialog(context),
                    textColor: AppTheme.errorRed,
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignInPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 64,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            const Text(
              'Faça login para acessar seu perfil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Acesse seus pedidos, endereços,\nformas de pagamento e muito mais',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to sign in
                  context.read<AuthProvider>().signIn('user@example.com', 'password');
                },
                child: const Text('Fazer login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubeCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryRed, AppTheme.primaryRed.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showClubeBottomSheet(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Clube iFood',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Cupons de desconto todo mês',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'A partir de R\$ 12,90/mês',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Assinar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClubeActiveCard(BuildContext context, DateTime? expiryDate) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.successGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.successGreen,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Clube iFood Ativo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                if (expiryDate != null)
                  Text(
                    'Válido até ${expiryDate.day}/${expiryDate.month}/${expiryDate.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textGrey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (textColor ?? AppTheme.primaryRed).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: textColor ?? AppTheme.primaryRed,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppTheme.textDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.textGrey,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.textGrey,
      ),
      onTap: onTap,
    );
  }

  void _showClubeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'Clube iFood',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Assine o Clube iFood e receba cupons de desconto todos os meses para usar em seus restaurantes favoritos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textGrey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Plano Mensal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'R\$ 12,90/mês',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryRed,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '5 cupons de desconto',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthProvider>().subscribeToClube();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Assinar Clube iFood'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().signOut();
              Navigator.of(context).pop();
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}