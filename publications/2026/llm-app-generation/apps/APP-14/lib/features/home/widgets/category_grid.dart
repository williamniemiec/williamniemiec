import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      CategoryItem(
        icon: Icons.restaurant,
        label: 'Restaurantes',
        color: AppTheme.primaryRed,
        onTap: () => context.push('/search?category=restaurants'),
      ),
      CategoryItem(
        icon: Icons.shopping_cart,
        label: 'Mercado',
        color: Colors.green,
        onTap: () => context.push('/search?category=supermarket'),
      ),
      CategoryItem(
        icon: Icons.local_pharmacy,
        label: 'Farmácia',
        color: Colors.blue,
        onTap: () => context.push('/search?category=pharmacy'),
      ),
      CategoryItem(
        icon: Icons.pets,
        label: 'Pet Shop',
        color: Colors.orange,
        onTap: () => context.push('/search?category=petshop'),
      ),
      CategoryItem(
        icon: Icons.local_drink,
        label: 'Bebidas',
        color: Colors.purple,
        onTap: () => context.push('/search?category=drinks'),
      ),
      CategoryItem(
        icon: Icons.cake,
        label: 'Doces',
        color: Colors.pink,
        onTap: () => context.push('/search?category=desserts'),
      ),
      CategoryItem(
        icon: Icons.coffee,
        label: 'Café',
        color: Colors.brown,
        onTap: () => context.push('/search?category=coffee'),
      ),
      CategoryItem(
        icon: Icons.more_horiz,
        label: 'Mais',
        color: AppTheme.textGrey,
        onTap: () => context.push('/search'),
      ),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'O que você está procurando?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: category.onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        category.icon,
                        color: category.color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textDark,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  CategoryItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}