import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/test_result.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TestResult> _testResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadTestResults();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTestResults() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _testResults = [
        TestResult(
          id: '1',
          patientId: '1',
          testName: 'Complete Blood Count',
          category: 'Laboratory',
          orderedDate: DateTime.now().subtract(const Duration(days: 2)),
          resultDate: DateTime.now().subtract(const Duration(hours: 1)),
          orderingProvider: 'Dr. Sarah Johnson',
          overallStatus: TestResultStatus.normal,
          values: [
            TestResultValue(
              name: 'White Blood Cells',
              value: '7.2',
              unit: 'K/uL',
              referenceRange: '4.0-11.0',
              status: TestResultStatus.normal,
            ),
            TestResultValue(
              name: 'Red Blood Cells',
              value: '4.5',
              unit: 'M/uL',
              referenceRange: '4.2-5.4',
              status: TestResultStatus.normal,
            ),
            TestResultValue(
              name: 'Hemoglobin',
              value: '14.2',
              unit: 'g/dL',
              referenceRange: '12.0-16.0',
              status: TestResultStatus.normal,
            ),
          ],
        ),
        TestResult(
          id: '2',
          patientId: '1',
          testName: 'Lipid Panel',
          category: 'Laboratory',
          orderedDate: DateTime.now().subtract(const Duration(days: 7)),
          resultDate: DateTime.now().subtract(const Duration(days: 5)),
          orderingProvider: 'Dr. Sarah Johnson',
          overallStatus: TestResultStatus.abnormal,
          values: [
            TestResultValue(
              name: 'Total Cholesterol',
              value: '220',
              unit: 'mg/dL',
              referenceRange: '<200',
              status: TestResultStatus.abnormal,
              notes: 'Slightly elevated',
            ),
            TestResultValue(
              name: 'HDL Cholesterol',
              value: '45',
              unit: 'mg/dL',
              referenceRange: '>40',
              status: TestResultStatus.normal,
            ),
            TestResultValue(
              name: 'LDL Cholesterol',
              value: '150',
              unit: 'mg/dL',
              referenceRange: '<100',
              status: TestResultStatus.abnormal,
              notes: 'Elevated - consider dietary changes',
            ),
          ],
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Record'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Test Results'),
            Tab(text: 'Health Summary'),
            Tab(text: 'Medications'),
            Tab(text: 'Immunizations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTestResultsTab(),
          _buildHealthSummaryTab(),
          _buildMedicationsTab(),
          _buildImmunizationsTab(),
        ],
      ),
    );
  }

  Widget _buildTestResultsTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_testResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.science_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No test results available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your test results will appear here when available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTestResults,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _testResults.length,
        itemBuilder: (context, index) {
          final testResult = _testResults[index];
          return _TestResultCard(
            testResult: testResult,
            onTap: () => _showTestResultDetails(testResult),
          );
        },
      ),
    );
  }

  Widget _buildHealthSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummarySection(
            'Current Health Issues',
            [
              'Hypertension - Well controlled',
              'Type 2 Diabetes - Managed with medication',
            ],
            Icons.medical_services_outlined,
            AppColors.healthRed,
          ),
          const SizedBox(height: 24),
          _buildSummarySection(
            'Allergies',
            [
              'Penicillin - Severe reaction',
              'Shellfish - Mild reaction',
            ],
            Icons.warning_outlined,
            AppColors.warning,
          ),
          const SizedBox(height: 24),
          _buildSummarySection(
            'Family History',
            [
              'Heart Disease - Father',
              'Diabetes - Mother',
              'Cancer - Maternal grandmother',
            ],
            Icons.family_restroom_outlined,
            AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _MedicationCard(
            name: 'Lisinopril',
            dosage: '10mg',
            frequency: 'Once daily',
            prescriber: 'Dr. Sarah Johnson',
            refillsRemaining: 3,
          ),
          const SizedBox(height: 16),
          _MedicationCard(
            name: 'Metformin',
            dosage: '500mg',
            frequency: 'Twice daily',
            prescriber: 'Dr. Sarah Johnson',
            refillsRemaining: 1,
          ),
          const SizedBox(height: 16),
          _MedicationCard(
            name: 'Atorvastatin',
            dosage: '20mg',
            frequency: 'Once daily at bedtime',
            prescriber: 'Dr. Sarah Johnson',
            refillsRemaining: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildImmunizationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ImmunizationCard(
            name: 'COVID-19 Vaccine',
            date: DateTime.now().subtract(const Duration(days: 90)),
            provider: 'Main Hospital',
            nextDue: DateTime.now().add(const Duration(days: 275)),
          ),
          const SizedBox(height: 16),
          _ImmunizationCard(
            name: 'Influenza Vaccine',
            date: DateTime.now().subtract(const Duration(days: 180)),
            provider: 'Main Hospital',
            nextDue: DateTime.now().add(const Duration(days: 185)),
          ),
          const SizedBox(height: 16),
          _ImmunizationCard(
            name: 'Tetanus/Diphtheria',
            date: DateTime.now().subtract(const Duration(days: 1825)),
            provider: 'Family Clinic',
            nextDue: DateTime.now().add(const Duration(days: 1825)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String title, List<String> items, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6, right: 12),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showTestResultDetails(TestResult testResult) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(testResult.testName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Ordered by', testResult.orderingProvider),
              _buildDetailRow('Result Date', 
                  DateFormat('MMM dd, yyyy \'at\' h:mm a').format(testResult.resultDate!)),
              _buildDetailRow('Status', testResult.statusDisplayName),
              const SizedBox(height: 16),
              Text(
                'Results',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...testResult.values.map((value) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          value.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: value.status == TestResultStatus.normal
                                ? AppColors.testNormal.withOpacity(0.1)
                                : AppColors.testAbnormal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            value.status == TestResultStatus.normal ? 'Normal' : 'Abnormal',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: value.status == TestResultStatus.normal
                                  ? AppColors.testNormal
                                  : AppColors.testAbnormal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${value.value} ${value.unit}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (value.referenceRange != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Reference: ${value.referenceRange}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    if (value.notes != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        value.notes!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _TestResultCard extends StatelessWidget {
  final TestResult testResult;
  final VoidCallback onTap;

  const _TestResultCard({
    required this.testResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.science_outlined,
                  color: _getStatusColor(),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testResult.testName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ordered by ${testResult.orderingProvider}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (testResult.resultDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Result: ${DateFormat('MMM dd, yyyy').format(testResult.resultDate!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      testResult.statusDisplayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (testResult.overallStatus) {
      case TestResultStatus.normal:
        return AppColors.testNormal;
      case TestResultStatus.abnormal:
        return AppColors.testAbnormal;
      case TestResultStatus.critical:
        return AppColors.testAbnormal;
      case TestResultStatus.pending:
        return AppColors.testPending;
    }
  }
}

class _MedicationCard extends StatelessWidget {
  final String name;
  final String dosage;
  final String frequency;
  final String prescriber;
  final int refillsRemaining;

  const _MedicationCard({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.prescriber,
    required this.refillsRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.healthBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.medication_outlined,
                    color: AppColors.healthBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$dosage • $frequency',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: refillsRemaining > 0 ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Refill request feature coming soon!'),
                      ),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Refill'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Prescribed by $prescriber',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '$refillsRemaining refill${refillsRemaining != 1 ? 's' : ''} remaining',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: refillsRemaining > 0 ? AppColors.testNormal : AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImmunizationCard extends StatelessWidget {
  final String name;
  final DateTime date;
  final String provider;
  final DateTime nextDue;

  const _ImmunizationCard({
    required this.name,
    required this.date,
    required this.provider,
    required this.nextDue,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = nextDue.isBefore(DateTime.now());
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.vaccines_outlined,
                color: AppColors.secondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Given: ${DateFormat('MMM dd, yyyy').format(date)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Provider: $provider',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Next due: ${DateFormat('MMM dd, yyyy').format(nextDue)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isOverdue ? AppColors.warning : AppColors.textSecondary,
                      fontWeight: isOverdue ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (isOverdue)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Overdue',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.warning,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}