import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/home/screens/home_screen.dart';
import 'features/payments/screens/payments_screen.dart';
import 'features/wallet/screens/wallet_screen.dart';
import 'features/deals/screens/deals_screen.dart';

void main() {
  runApp(const PayPalApp());
}

class PayPalApp extends StatelessWidget {
  const PayPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PaymentsScreen(),
    const WalletScreen(),
    const DealsScreen(),
  ];

  final List<BottomNavigationBarItem> _navigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.payment_outlined),
      activeIcon: Icon(Icons.payment),
      label: 'Payments',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_balance_wallet_outlined),
      activeIcon: Icon(Icons.account_balance_wallet),
      label: 'Wallet',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.local_offer_outlined),
      activeIcon: Icon(Icons.local_offer),
      label: 'Deals',
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: _navigationItems,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.paypalBlue,
        unselectedItemColor: AppTheme.mediumGray,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
