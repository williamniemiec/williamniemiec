import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/providers/home_provider.dart';
import 'features/account/providers/account_provider.dart';
import 'features/credit_card/providers/credit_card_provider.dart';
import 'features/pix/providers/pix_provider.dart';
import 'features/shopping/providers/shopping_provider.dart';

void main() {
  runApp(const NubankApp());
}

class NubankApp extends StatelessWidget {
  const NubankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => CreditCardProvider()),
        ChangeNotifierProvider(create: (_) => PixProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainNavigationScreen(),
        debugShowCheckedModeBanner: false,
      ),
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
    const PlanningScreen(),
    const ShoppingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Vida financeira',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Planejamento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shopping',
          ),
        ],
      ),
    );
  }
}

// Placeholder screens - will be implemented later
class PlanningScreen extends StatelessWidget {
  const PlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planejamento'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.savings,
              size: 64,
              color: AppTheme.primaryPurple,
            ),
            SizedBox(height: 16),
            Text(
              'Caixinhas e Investimentos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Em breve você poderá gerenciar suas\ncaixinhas e investimentos aqui.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 64,
              color: AppTheme.primaryPurple,
            ),
            SizedBox(height: 16),
            Text(
              'Nubank Shopping',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Descubra ofertas exclusivas e\nganhe cashback em suas compras.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
