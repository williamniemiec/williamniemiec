import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_provider.dart';
import 'features/home/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  runApp(const BetanoApp());
}

class BetanoApp extends StatelessWidget {
  const BetanoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'Betano',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: appProvider.isAuthenticated ? const MainScreen() : const LoginScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          body: IndexedStack(
            index: appProvider.currentBottomNavIndex,
            children: const [
              HomeScreen(),
              SportsScreen(),
              LiveBettingScreen(),
              CasinoScreen(),
              AccountScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: appProvider.currentBottomNavIndex,
            onTap: appProvider.setBottomNavIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_soccer),
                label: 'Esportes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.live_tv),
                label: 'Ao Vivo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.casino),
                label: 'Casino',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Conta',
              ),
            ],
          ),
          floatingActionButton: appProvider.betSlip.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: () => appProvider.toggleBetSlipVisibility(),
                  backgroundColor: AppTheme.betSlipColor,
                  foregroundColor: AppTheme.textPrimaryColor,
                  icon: const Icon(Icons.receipt),
                  label: Text(
                    'Cupom (${appProvider.betSlip.selectionCount})',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                )
              : null,
        );
      },
    );
  }
}

// Placeholder screens - will be implemented in next steps
class SportsScreen extends StatelessWidget {
  const SportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esportes'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    appProvider.formattedBalance,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_soccer,
              size: 64,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'Seção de Esportes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Apostas esportivas em desenvolvimento',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveBettingScreen extends StatelessWidget {
  const LiveBettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ao Vivo'),
        backgroundColor: AppTheme.liveColor,
        foregroundColor: Colors.white,
        actions: [
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    appProvider.formattedBalance,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.live_tv,
              size: 64,
              color: AppTheme.liveColor,
            ),
            SizedBox(height: 16),
            Text(
              'Apostas Ao Vivo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Eventos ao vivo em desenvolvimento',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CasinoScreen extends StatelessWidget {
  const CasinoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casino'),
        backgroundColor: AppTheme.jackpotColor,
        foregroundColor: AppTheme.textPrimaryColor,
        actions: [
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    appProvider.formattedBalance,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.casino,
              size: 64,
              color: AppTheme.jackpotColor,
            ),
            SizedBox(height: 16),
            Text(
              'Casino Online',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Jogos de casino em desenvolvimento',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Conta'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final user = appProvider.currentUser;
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // User Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppTheme.primaryColor,
                            child: Text(
                              user?.firstName.substring(0, 1).toUpperCase() ?? 'U',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.fullName ?? 'Usuário',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user?.email ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: user?.isVerified == true
                                        ? AppTheme.accentColor
                                        : AppTheme.warningColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user?.isVerified == true
                                        ? 'Verificado'
                                        : 'Não Verificado',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Saldo Disponível',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              appProvider.formattedBalance,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to deposit screen
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Depositar'),
                      style: AppTheme.primaryButtonStyle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to withdraw screen
                      },
                      icon: const Icon(Icons.remove),
                      label: const Text('Sacar'),
                      style: AppTheme.secondaryButtonStyle,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Menu Options
              _buildMenuTile(
                icon: Icons.history,
                title: 'Histórico de Apostas',
                onTap: () {},
              ),
              _buildMenuTile(
                icon: Icons.account_balance_wallet,
                title: 'Transações',
                onTap: () {},
              ),
              _buildMenuTile(
                icon: Icons.verified_user,
                title: 'Verificação de Conta',
                onTap: () {},
              ),
              _buildMenuTile(
                icon: Icons.security,
                title: 'Jogo Responsável',
                onTap: () {},
              ),
              _buildMenuTile(
                icon: Icons.settings,
                title: 'Configurações',
                onTap: () {},
              ),
              _buildMenuTile(
                icon: Icons.help,
                title: 'Ajuda e Suporte',
                onTap: () {},
              ),
              
              const SizedBox(height: 24),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sair da Conta'),
                        content: const Text('Tem certeza que deseja sair?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              appProvider.logout();
                            },
                            style: AppTheme.dangerButtonStyle,
                            child: const Text('Sair'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair da Conta'),
                  style: AppTheme.dangerButtonStyle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
