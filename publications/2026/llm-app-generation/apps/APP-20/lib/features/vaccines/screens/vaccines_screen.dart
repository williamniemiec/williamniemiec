import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../main_navigation.dart';
import '../../../shared/models/vaccination.dart';
import '../../auth/providers/auth_provider.dart';

class VaccinesScreen extends StatefulWidget {
  const VaccinesScreen({super.key});

  @override
  State<VaccinesScreen> createState() => _VaccinesScreenState();
}

class _VaccinesScreenState extends State<VaccinesScreen> {
  List<Vaccination> _vaccinations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVaccinations();
  }

  Future<void> _loadVaccinations() async {
    // Simulate loading vaccinations data
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _vaccinations = _getMockVaccinations();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Vacinas'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16),
          Text(
            'Carregando histórico de vacinação...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // COVID-19 Certificate Button
          _buildCovidCertificateButton(),
          
          const SizedBox(height: 24),
          
          // Vaccination History
          _buildVaccinationHistory(),
        ],
      ),
    );
  }

  Widget _buildCovidCertificateButton() {
    final covidVaccinations = _vaccinations.where((v) => v.isCovidVaccine).toList();
    final hasCovidVaccination = covidVaccinations.isNotEmpty;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.vaccineColor,
            AppColors.vaccineColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.vaccineColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.verified_user,
                  color: AppColors.textOnPrimary,
                  size: 32,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Certificado Nacional de',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    Text(
                      'Vacinação COVID-19',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasCovidVaccination 
                          ? '${covidVaccinations.length} dose(s) registrada(s)'
                          : 'Nenhuma dose registrada',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textOnPrimary.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: hasCovidVaccination 
                  ? () => NavigationHelper.navigateToVaccineCertificate(context)
                  : null,
              icon: const Icon(Icons.download),
              label: Text(
                hasCovidVaccination 
                    ? 'Gerar Certificado'
                    : 'Certificado Indisponível',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textOnPrimary,
                foregroundColor: AppColors.vaccineColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationHistory() {
    if (_vaccinations.isEmpty) {
      return _buildEmptyState();
    }

    // Group vaccinations by vaccine name
    final groupedVaccinations = <String, List<Vaccination>>{};
    for (final vaccination in _vaccinations) {
      final key = vaccination.vaccineName;
      groupedVaccinations[key] = (groupedVaccinations[key] ?? [])..add(vaccination);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Histórico de Vacinação',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 16),
        
        ...groupedVaccinations.entries.map((entry) {
          final vaccineName = entry.key;
          final vaccinations = entry.value;
          vaccinations.sort((a, b) => b.administrationDate.compareTo(a.administrationDate));
          
          return _buildVaccineGroup(vaccineName, vaccinations);
        }).toList(),
      ],
    );
  }

  Widget _buildVaccineGroup(String vaccineName, List<Vaccination> vaccinations) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: vaccinations.first.isCovidVaccine 
                ? AppColors.vaccineColor.withOpacity(0.1)
                : AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.vaccines,
            color: vaccinations.first.isCovidVaccine 
                ? AppColors.vaccineColor
                : AppColors.secondary,
            size: 24,
          ),
        ),
        title: Text(
          vaccineName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${vaccinations.length} dose(s) • Última: ${vaccinations.first.formattedDate}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        children: vaccinations.map((vaccination) => _buildVaccinationItem(vaccination)).toList(),
      ),
    );
  }

  Widget _buildVaccinationItem(Vaccination vaccination) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  vaccination.doseDescription,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: vaccination.isValid 
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  vaccination.isValid ? 'Válida' : 'Pendente',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: vaccination.isValid ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          _buildInfoRow('Data:', vaccination.formattedDate),
          _buildInfoRow('Fabricante:', vaccination.manufacturer),
          _buildInfoRow('Lote:', vaccination.batchNumber),
          _buildInfoRow('Local:', vaccination.healthFacility),
          
          if (vaccination.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Observações: ${vaccination.notes}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        children: [
          Icon(
            Icons.vaccines_outlined,
            size: 64,
            color: AppColors.textLight,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Nenhuma vacinação encontrada',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Suas vacinas aplicadas no SUS aparecerão aqui automaticamente.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Vaccination> _getMockVaccinations() {
    final userId = Provider.of<AuthProvider>(context, listen: false).currentUser?.id ?? 'demo_user';
    
    return [
      // COVID-19 Vaccinations
      Vaccination(
        id: 'vacc_1',
        userId: userId,
        vaccineName: 'COVID-19 - CoronaVac',
        vaccineType: 'COVID-19',
        manufacturer: 'Sinovac/Butantan',
        batchNumber: 'CV001',
        administrationDate: DateTime(2021, 3, 15),
        healthFacility: 'UBS Centro - Brasília/DF',
        healthProfessional: 'Dr. Maria Silva',
        doseNumber: 1,
        totalDoses: 2,
        lotNumber: 'LOT001CV',
        expirationDate: DateTime(2022, 3, 15),
        administrationSite: 'Braço esquerdo',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      Vaccination(
        id: 'vacc_2',
        userId: userId,
        vaccineName: 'COVID-19 - CoronaVac',
        vaccineType: 'COVID-19',
        manufacturer: 'Sinovac/Butantan',
        batchNumber: 'CV002',
        administrationDate: DateTime(2021, 5, 17),
        healthFacility: 'UBS Centro - Brasília/DF',
        healthProfessional: 'Dr. João Santos',
        doseNumber: 2,
        totalDoses: 2,
        lotNumber: 'LOT002CV',
        expirationDate: DateTime(2022, 5, 17),
        administrationSite: 'Braço direito',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      Vaccination(
        id: 'vacc_3',
        userId: userId,
        vaccineName: 'COVID-19 - Pfizer',
        vaccineType: 'COVID-19',
        manufacturer: 'Pfizer/BioNTech',
        batchNumber: 'PF001',
        administrationDate: DateTime(2022, 1, 10),
        healthFacility: 'Centro de Vacinação - Brasília/DF',
        healthProfessional: 'Enf. Ana Costa',
        doseNumber: 1,
        totalDoses: 1,
        lotNumber: 'LOT001PF',
        expirationDate: DateTime(2023, 1, 10),
        administrationSite: 'Braço esquerdo',
        notes: 'Dose de reforço',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      // Other vaccinations
      Vaccination(
        id: 'vacc_4',
        userId: userId,
        vaccineName: 'Influenza (Gripe)',
        vaccineType: 'Influenza',
        manufacturer: 'Sanofi Pasteur',
        batchNumber: 'INF2023',
        administrationDate: DateTime(2023, 4, 20),
        healthFacility: 'UBS Asa Norte - Brasília/DF',
        healthProfessional: 'Enf. Carlos Lima',
        doseNumber: 1,
        totalDoses: 1,
        lotNumber: 'LOT2023INF',
        expirationDate: DateTime(2024, 4, 20),
        administrationSite: 'Braço direito',
        notes: 'Campanha anual de vacinação',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}