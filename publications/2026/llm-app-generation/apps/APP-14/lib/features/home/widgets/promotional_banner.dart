import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class PromotionalBanner extends StatefulWidget {
  const PromotionalBanner({super.key});

  @override
  State<PromotionalBanner> createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends State<PromotionalBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<BannerItem> _banners = [
    BannerItem(
      title: 'Clube iFood',
      subtitle: 'Cupons de desconto todo mês',
      description: 'Assine por R\$ 12,90/mês',
      backgroundColor: AppTheme.primaryRed,
      textColor: Colors.white,
      buttonText: 'Assinar',
      onTap: () {},
    ),
    BannerItem(
      title: 'Frete Grátis',
      subtitle: 'Em pedidos acima de R\$ 30',
      description: 'Válido para restaurantes selecionados',
      backgroundColor: Colors.green,
      textColor: Colors.white,
      buttonText: 'Ver restaurantes',
      onTap: () {},
    ),
    BannerItem(
      title: 'Super Ofertas',
      subtitle: 'Até 50% de desconto',
      description: 'Promoções imperdíveis',
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      buttonText: 'Ver ofertas',
      onTap: () {},
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 140,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        banner.backgroundColor,
                        banner.backgroundColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: banner.onTap,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    banner.title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: banner.textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    banner.subtitle,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: banner.textColor.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    banner.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: banner.textColor.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: banner.textColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: banner.textColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                banner.buttonText,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: banner.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppTheme.primaryRed
                      : AppTheme.borderGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class BannerItem {
  final String title;
  final String subtitle;
  final String description;
  final Color backgroundColor;
  final Color textColor;
  final String buttonText;
  final VoidCallback onTap;

  BannerItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.backgroundColor,
    required this.textColor,
    required this.buttonText,
    required this.onTap,
  });
}