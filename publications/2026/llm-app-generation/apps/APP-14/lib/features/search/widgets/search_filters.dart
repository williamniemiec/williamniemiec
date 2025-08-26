import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SearchFilters extends StatefulWidget {
  final bool freeDelivery;
  final bool promotions;
  final double maxDeliveryTime;
  final double minRating;
  final Function(bool, bool, double, double) onFiltersChanged;

  const SearchFilters({
    super.key,
    required this.freeDelivery,
    required this.promotions,
    required this.maxDeliveryTime,
    required this.minRating,
    required this.onFiltersChanged,
  });

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  late bool _freeDelivery;
  late bool _promotions;
  late double _maxDeliveryTime;
  late double _minRating;

  @override
  void initState() {
    super.initState();
    _freeDelivery = widget.freeDelivery;
    _promotions = widget.promotions;
    _maxDeliveryTime = widget.maxDeliveryTime;
    _minRating = widget.minRating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Filtros',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Limpar'),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Filters Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Filters
                  _buildSectionTitle('Filtros rápidos'),
                  const SizedBox(height: 12),
                  
                  _buildSwitchTile(
                    'Frete grátis',
                    'Apenas restaurantes com frete grátis',
                    _freeDelivery,
                    (value) => setState(() => _freeDelivery = value),
                  ),
                  
                  _buildSwitchTile(
                    'Promoções',
                    'Restaurantes com ofertas especiais',
                    _promotions,
                    (value) => setState(() => _promotions = value),
                  ),

                  const SizedBox(height: 24),

                  // Delivery Time Filter
                  _buildSectionTitle('Tempo de entrega'),
                  const SizedBox(height: 12),
                  
                  Text(
                    'Até ${_maxDeliveryTime.toInt()} minutos',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textDark,
                    ),
                  ),
                  
                  Slider(
                    value: _maxDeliveryTime,
                    min: 15,
                    max: 90,
                    divisions: 15,
                    activeColor: AppTheme.primaryRed,
                    inactiveColor: AppTheme.borderGrey,
                    onChanged: (value) {
                      setState(() => _maxDeliveryTime = value);
                    },
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '15 min',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                        ),
                      ),
                      Text(
                        '90 min',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Rating Filter
                  _buildSectionTitle('Avaliação mínima'),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _minRating == 0 
                            ? 'Qualquer avaliação' 
                            : '${_minRating.toInt()}+ estrelas',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    activeColor: AppTheme.primaryRed,
                    inactiveColor: AppTheme.borderGrey,
                    onChanged: (value) {
                      setState(() => _minRating = value);
                    },
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Qualquer',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                        ),
                      ),
                      Text(
                        '5 estrelas',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Apply Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Aplicar filtros'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppTheme.textDark,
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textGrey,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryRed,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _freeDelivery = false;
      _promotions = false;
      _maxDeliveryTime = 60;
      _minRating = 0;
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(
      _freeDelivery,
      _promotions,
      _maxDeliveryTime,
      _minRating,
    );
    Navigator.of(context).pop();
  }
}