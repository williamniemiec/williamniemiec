import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/vaccination.dart';
import '../../auth/providers/auth_provider.dart';

class VaccineCertificateScreen extends StatefulWidget {
  const VaccineCertificateScreen({super.key});

  @override
  State<VaccineCertificateScreen> createState() => _VaccineCertificateScreenState();
}

class _VaccineCertificateScreenState extends State<VaccineCertificateScreen> {
  String _selectedLanguage = 'pt';
  List<Vaccination> _covidVaccinations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCovidVaccinations();
  }

  Future<void> _loadCovidVaccinations() async {
    // Simulate loading COVID vaccinations
    await Future.delayed(const Duration(seconds: 1));
    
    final userId = Provider.of<AuthProvider>(context, listen: false).currentUser?.id ?? 'demo_user';
    
    setState(() {
      _covidVaccinations = _getMockCovidVaccinations(userId);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showLanguageDialog,
            icon: const Icon(Icons.language),
          ),
          IconButton(
            onPressed: _exportToPDF,
            icon: const Icon(Icons.download),
          ),
          IconButton(
            onPressed: _shareCertificate,
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: _isLoading ? _buildLoadingState() : _buildCertificate(),
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
            'Gerando certificado...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificate() {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    
    if (user == null || _covidVaccinations.isEmpty) {
      return _buildNoCertificateState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.certificateBackground,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: AppColors.certificateBorder, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              _buildCertificateHeader(),
              
              const SizedBox(height: 24),
              
              // User Information
              _buildUserInformation(user),
              
              const SizedBox(height: 24),
              
              // QR Code
              _buildQRCode(user),
              
              const SizedBox(height: 24),
              
              // Vaccination Information
              _buildVaccinationInformation(),
              
              const SizedBox(height: 24),
              
              // Footer
              _buildCertificateFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateHeader() {
    return Column(
      children: [
        // Brazilian Government Logo placeholder
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.health_and_safety,
            color: AppColors.textOnPrimary,
            size: 40,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Text(
          _getCertificateTitle(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        Text(
          _getSubtitle(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUserInformation(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getFieldLabel('name'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            user.name.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getFieldLabel('birthDate'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatDate(user.dateOfBirth),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getFieldLabel('document'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatCPF(user.cpf),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
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

  Widget _buildQRCode(user) {
    final qrData = _generateQRData(user);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.qrCodeBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 200.0,
            backgroundColor: AppColors.qrCodeBackground,
            foregroundColor: AppColors.textPrimary,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            _getQRCodeLabel(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getVaccinationInfoTitle(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        ..._covidVaccinations.asMap().entries.map((entry) {
          final index = entry.key;
          final vaccination = entry.value;
          return _buildVaccinationItem(vaccination, index + 1);
        }).toList(),
      ],
    );
  }

  Widget _buildVaccinationItem(Vaccination vaccination, int doseNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_getDoseLabel()} $doseNumber',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          _buildVaccinationDetail(_getFieldLabel('vaccine'), vaccination.vaccineName),
          _buildVaccinationDetail(_getFieldLabel('manufacturer'), vaccination.manufacturer),
          _buildVaccinationDetail(_getFieldLabel('date'), vaccination.formattedDate),
          _buildVaccinationDetail(_getFieldLabel('batch'), vaccination.batchNumber),
          _buildVaccinationDetail(_getFieldLabel('facility'), vaccination.healthFacility),
        ],
      ),
    );
  }

  Widget _buildVaccinationDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
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

  Widget _buildCertificateFooter() {
    return Column(
      children: [
        const Divider(color: AppColors.divider),
        
        const SizedBox(height: 16),
        
        Text(
          _getFooterText(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        Text(
          _getGeneratedDate(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNoCertificateState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_outlined,
            size: 64,
            color: AppColors.warning,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            _getNoCertificateTitle(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            _getNoCertificateMessage(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecionar Idioma'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppConstants.certificateLanguages.map((lang) {
              return ListTile(
                title: Text(AppConstants.languageNames[lang]!),
                leading: Radio<String>(
                  value: lang,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _exportToPDF() {
    // TODO: Implement PDF export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de exportação PDF em desenvolvimento'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _shareCertificate() {
    // TODO: Implement certificate sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de compartilhamento em desenvolvimento'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  String _generateQRData(user) {
    // Generate QR code data with certificate information
    final certificateData = {
      'type': 'COVID19_VACCINATION_CERTIFICATE',
      'country': 'BR',
      'name': user.name,
      'cpf': user.cpf,
      'cns': user.cns,
      'birthDate': user.dateOfBirth.toIso8601String(),
      'vaccinations': _covidVaccinations.map((v) => {
        'vaccine': v.vaccineName,
        'manufacturer': v.manufacturer,
        'date': v.administrationDate.toIso8601String(),
        'batch': v.batchNumber,
        'dose': v.doseNumber,
      }).toList(),
      'generatedAt': DateTime.now().toIso8601String(),
      'language': _selectedLanguage,
    };
    
    // In a real implementation, this would be a properly formatted and signed certificate
    return 'CONECTE_SUS_COVID_CERT:${certificateData.toString()}';
  }

  // Localization methods
  String _getTitle() {
    switch (_selectedLanguage) {
      case 'en':
        return 'COVID-19 Vaccination Certificate';
      case 'es':
        return 'Certificado de Vacunación COVID-19';
      default:
        return 'Certificado de Vacinação COVID-19';
    }
  }

  String _getCertificateTitle() {
    switch (_selectedLanguage) {
      case 'en':
        return 'COVID-19 VACCINATION CERTIFICATE';
      case 'es':
        return 'CERTIFICADO DE VACUNACIÓN COVID-19';
      default:
        return 'CERTIFICADO NACIONAL DE VACINAÇÃO COVID-19';
    }
  }

  String _getSubtitle() {
    switch (_selectedLanguage) {
      case 'en':
        return 'Ministry of Health - Brazil';
      case 'es':
        return 'Ministerio de Salud - Brasil';
      default:
        return 'Ministério da Saúde - Brasil';
    }
  }

  String _getFieldLabel(String field) {
    final labels = {
      'pt': {
        'name': 'Nome',
        'birthDate': 'Data de Nascimento',
        'document': 'CPF',
        'vaccine': 'Vacina',
        'manufacturer': 'Fabricante',
        'date': 'Data',
        'batch': 'Lote',
        'facility': 'Local',
      },
      'en': {
        'name': 'Name',
        'birthDate': 'Date of Birth',
        'document': 'CPF',
        'vaccine': 'Vaccine',
        'manufacturer': 'Manufacturer',
        'date': 'Date',
        'batch': 'Batch',
        'facility': 'Facility',
      },
      'es': {
        'name': 'Nombre',
        'birthDate': 'Fecha de Nacimiento',
        'document': 'CPF',
        'vaccine': 'Vacuna',
        'manufacturer': 'Fabricante',
        'date': 'Fecha',
        'batch': 'Lote',
        'facility': 'Local',
      },
    };
    
    return labels[_selectedLanguage]?[field] ?? field;
  }

  String _getDoseLabel() {
    switch (_selectedLanguage) {
      case 'en':
        return 'Dose';
      case 'es':
        return 'Dosis';
      default:
        return 'Dose';
    }
  }

  String _getQRCodeLabel() {
    switch (_selectedLanguage) {
      case 'en':
        return 'Scan to verify certificate authenticity';
      case 'es':
        return 'Escanear para verificar autenticidad del certificado';
      default:
        return 'Escaneie para verificar a autenticidade do certificado';
    }
  }

  String _getVaccinationInfoTitle() {
    switch (_selectedLanguage) {
      case 'en':
        return 'Vaccination Information';
      case 'es':
        return 'Información de Vacunación';
      default:
        return 'Informações de Vacinação';
    }
  }

  String _getFooterText() {
    switch (_selectedLanguage) {
      case 'en':
        return 'This certificate was issued by the Brazilian Ministry of Health through the Conecte SUS platform.';
      case 'es':
        return 'Este certificado fue emitido por el Ministerio de Salud de Brasil a través de la plataforma Conecte SUS.';
      default:
        return 'Este certificado foi emitido pelo Ministério da Saúde do Brasil através da plataforma Conecte SUS.';
    }
  }

  String _getGeneratedDate() {
    final now = DateTime.now();
    final formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    
    switch (_selectedLanguage) {
      case 'en':
        return 'Generated on: $formattedDate';
      case 'es':
        return 'Generado el: $formattedDate';
      default:
        return 'Gerado em: $formattedDate';
    }
  }

  String _getNoCertificateTitle() {
    switch (_selectedLanguage) {
      case 'en':
        return 'Certificate Not Available';
      case 'es':
        return 'Certificado No Disponible';
      default:
        return 'Certificado Não Disponível';
    }
  }

  String _getNoCertificateMessage() {
    switch (_selectedLanguage) {
      case 'en':
        return 'No COVID-19 vaccination records found. Please ensure your vaccinations are registered in the SUS system.';
      case 'es':
        return 'No se encontraron registros de vacunación COVID-19. Asegúrese de que sus vacunas estén registradas en el sistema SUS.';
      default:
        return 'Nenhum registro de vacinação COVID-19 encontrado. Certifique-se de que suas vacinas estejam registradas no sistema SUS.';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCPF(String cpf) {
    if (cpf.length == 11) {
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
    }
    return cpf;
  }

  List<Vaccination> _getMockCovidVaccinations(String userId) {
    return [
      Vaccination(
        id: 'vacc_covid_1',
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
        id: 'vacc_covid_2',
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
    ];
  }
}