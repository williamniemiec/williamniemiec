import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../main_navigation.dart';

class ActionsScreen extends StatefulWidget {
  const ActionsScreen({super.key});

  @override
  State<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ações'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            
            const SizedBox(height: 24),
            
            // Health Services Section
            _buildHealthServicesSection(),
            
            const SizedBox(height: 24),
            
            // Donor Services Section
            _buildDonorServicesSection(),
            
            const SizedBox(height: 24),
            
            // Documents Section
            _buildDocumentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.textOnSecondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: AppColors.textOnSecondary,
                  size: 32,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Serviços de Saúde',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textOnSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Acesse seus dados e serviços do SUS',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textOnSecondary.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthServicesSection() {
    final healthServices = [
      {
        'title': 'Histórico de Vacinas',
        'subtitle': 'Consulte suas vacinas e certificados',
        'icon': Icons.vaccines,
        'color': AppColors.vaccineColor,
        'onTap': () => NavigationHelper.navigateToVaccines(context),
      },
      {
        'title': 'Resultados de Exames',
        'subtitle': 'Veja os resultados dos seus exames',
        'icon': Icons.science,
        'color': AppColors.examColor,
        'onTap': () => NavigationHelper.navigateToExams(context),
      },
      {
        'title': 'Medicamentos',
        'subtitle': 'Histórico da Farmácia Popular',
        'icon': Icons.medication,
        'color': AppColors.medicationColor,
        'onTap': () => NavigationHelper.navigateToMedications(context),
      },
      {
        'title': 'Consultas Agendadas',
        'subtitle': 'Veja e gerencie suas consultas',
        'icon': Icons.calendar_today,
        'color': AppColors.appointmentColor,
        'onTap': () => NavigationHelper.navigateToAppointments(context),
      },
    ];

    return _buildSection(
      title: 'Serviços de Saúde',
      items: healthServices,
    );
  }

  Widget _buildDonorServicesSection() {
    final donorServices = [
      {
        'title': 'Doação de Órgãos',
        'subtitle': 'Registre-se como doador de órgãos',
        'icon': Icons.favorite,
        'color': AppColors.donorColor,
        'onTap': () => _showDonorDialog(context, 'órgãos'),
      },
      {
        'title': 'Doação de Sangue',
        'subtitle': 'Registre-se como doador de sangue',
        'icon': Icons.bloodtype,
        'color': AppColors.error,
        'onTap': () => _showDonorDialog(context, 'sangue'),
      },
    ];

    return _buildSection(
      title: 'Serviços de Doação',
      items: donorServices,
    );
  }

  Widget _buildDocumentsSection() {
    final documents = [
      {
        'title': 'Cartão Nacional de Saúde',
        'subtitle': 'Visualize seu CNS com QR Code',
        'icon': Icons.credit_card,
        'color': AppColors.primary,
        'onTap': () => NavigationHelper.navigateToCNSCard(context),
      },
      {
        'title': 'Certificado de Vacinação',
        'subtitle': 'Gere seu certificado COVID-19',
        'icon': Icons.verified_user,
        'color': AppColors.vaccineColor,
        'onTap': () => NavigationHelper.navigateToVaccineCertificate(context),
      },
    ];

    return _buildSection(
      title: 'Documentos',
      items: documents,
    );
  }

  Widget _buildSection({
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 16),
        
        ...items.map((item) => _buildServiceCard(
          title: item['title'] as String,
          subtitle: item['subtitle'] as String,
          icon: item['icon'] as IconData,
          color: item['color'] as Color,
          onTap: item['onTap'] as VoidCallback,
        )).toList(),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        elevation: 2,
        shadowColor: AppColors.cardShadow,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDonorDialog(BuildContext context, String donorType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Doação de ${donorType.toUpperCase()}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deseja se registrar como doador de $donorType?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        donorType == 'órgãos'
                            ? 'Sua decisão será registrada no sistema e poderá ser alterada a qualquer momento.'
                            : 'Você receberá informações sobre campanhas de doação de sangue.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _registerAsDonor(donorType);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: donorType == 'órgãos' 
                    ? AppColors.donorColor 
                    : AppColors.error,
              ),
              child: const Text('Registrar'),
            ),
          ],
        );
      },
    );
  }

  void _registerAsDonor(String donorType) {
    // Here you would implement the actual donor registration logic
    NavigationHelper.showSuccessSnackBar(
      context,
      'Registro como doador de $donorType realizado com sucesso!',
    );
  }
}