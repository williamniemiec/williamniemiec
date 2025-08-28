import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/screens/home_screen.dart';
import 'features/vaccines/screens/vaccines_screen.dart';
import 'features/actions/screens/actions_screen.dart';
import 'features/messages/screens/messages_screen.dart';
import 'features/profile/screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const ActionsScreen(),
    const MessagesScreen(),
    const ProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Início',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.medical_services_outlined),
      activeIcon: Icon(Icons.medical_services),
      label: 'Ações',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.message_outlined),
      activeIcon: Icon(Icons.message),
      label: 'Mensagens',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Check if user is authenticated
        if (!authProvider.isAuthenticated) {
          // Redirect to login if not authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.bottomNavBackground,
        selectedItemColor: AppColors.bottomNavSelected,
        unselectedItemColor: AppColors.bottomNavUnselected,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
        ),
        elevation: 0,
        items: _bottomNavItems,
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

// Navigation Helper Class
class NavigationHelper {
  static void navigateToVaccines(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VaccinesScreen(),
      ),
    );
  }

  static void navigateToVaccineCertificate(BuildContext context) {
    Navigator.of(context).pushNamed('/vaccine-certificate');
  }

  static void navigateToCNSCard(BuildContext context) {
    Navigator.of(context).pushNamed('/cns-card');
  }

  static void navigateToExams(BuildContext context) {
    Navigator.of(context).pushNamed('/exams');
  }

  static void navigateToMedications(BuildContext context) {
    Navigator.of(context).pushNamed('/medications');
  }

  static void navigateToAppointments(BuildContext context) {
    Navigator.of(context).pushNamed('/appointments');
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed('/profile');
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair do App'),
          content: const Text('Tem certeza que deseja sair do Conecte SUS?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                if (context.mounted) {
                  navigateToLogin(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  static void showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Em Breve'),
          content: Text('A funcionalidade "$feature" estará disponível em breve.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}