import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/blood_pressure_reading.dart';
import '../models/user.dart';

class PdfService {
  static final PdfService _instance = PdfService._internal();
  factory PdfService() => _instance;
  PdfService._internal();

  Future<File> generateBloodPressureReport({
    required List<BloodPressureReading> readings,
    User? user,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final pdf = pw.Document();

    // Calculate statistics
    final stats = _calculateStatistics(readings);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(user),
            pw.SizedBox(height: 20),
            _buildDateRange(startDate, endDate),
            pw.SizedBox(height: 20),
            _buildSummaryStats(stats),
            pw.SizedBox(height: 30),
            _buildReadingsTable(readings),
            pw.SizedBox(height: 20),
            _buildCategoryBreakdown(readings),
            pw.SizedBox(height: 20),
            _buildFooter(),
          ];
        },
      ),
    );

    // Save PDF to temporary directory
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/blood_pressure_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  pw.Widget _buildHeader(User? user) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Blood Pressure Report',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 10),
        if (user != null) ...[
          pw.Text('Patient: ${user.name}', style: const pw.TextStyle(fontSize: 14)),
          if (user.age != null) pw.Text('Age: ${user.age}', style: const pw.TextStyle(fontSize: 14)),
          if (user.email != null) pw.Text('Email: ${user.email}', style: const pw.TextStyle(fontSize: 14)),
        ],
        pw.Text(
          'Generated on: ${DateFormat('MMMM dd, yyyy HH:mm').format(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
        ),
        pw.Divider(thickness: 2, color: PdfColors.blue800),
      ],
    );
  }

  pw.Widget _buildDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null && endDate == null) return pw.SizedBox();

    String dateRangeText = 'Report Period: ';
    if (startDate != null && endDate != null) {
      dateRangeText += '${DateFormat('MMM dd, yyyy').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}';
    } else if (startDate != null) {
      dateRangeText += 'From ${DateFormat('MMM dd, yyyy').format(startDate)}';
    } else if (endDate != null) {
      dateRangeText += 'Until ${DateFormat('MMM dd, yyyy').format(endDate)}';
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Text(dateRangeText, style: const pw.TextStyle(fontSize: 14)),
    );
  }

  pw.Widget _buildSummaryStats(Map<String, dynamic> stats) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Summary Statistics',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildStatCard('Total Readings', '${stats['totalReadings']}'),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: _buildStatCard('Average Systolic', '${stats['avgSystolic']} mmHg'),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: _buildStatCard('Average Diastolic', '${stats['avgDiastolic']} mmHg'),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: _buildStatCard('Average Pulse', '${stats['avgPulse']} bpm'),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildStatCard(String title, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          pw.Text(title, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
          pw.SizedBox(height: 5),
          pw.Text(value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  pw.Widget _buildReadingsTable(List<BloodPressureReading> readings) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Blood Pressure Readings',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1.5),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FlexColumnWidth(1),
            4: const pw.FlexColumnWidth(2),
            5: const pw.FlexColumnWidth(3),
          },
          children: [
            // Header row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _buildTableCell('Date & Time', isHeader: true),
                _buildTableCell('Systolic', isHeader: true),
                _buildTableCell('Diastolic', isHeader: true),
                _buildTableCell('Pulse', isHeader: true),
                _buildTableCell('Category', isHeader: true),
                _buildTableCell('Notes', isHeader: true),
              ],
            ),
            // Data rows
            ...readings.take(50).map((reading) => pw.TableRow(
              children: [
                _buildTableCell(reading.formattedDateTime),
                _buildTableCell('${reading.systolic}'),
                _buildTableCell('${reading.diastolic}'),
                _buildTableCell('${reading.pulse}'),
                _buildTableCell(reading.category.displayName),
                _buildTableCell(reading.notes ?? ''),
              ],
            )),
          ],
        ),
        if (readings.length > 50)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              'Note: Only the first 50 readings are shown in this report.',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _buildCategoryBreakdown(List<BloodPressureReading> readings) {
    final categoryCount = <BloodPressureCategory, int>{};
    for (final reading in readings) {
      categoryCount[reading.category] = (categoryCount[reading.category] ?? 0) + 1;
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Blood Pressure Category Breakdown',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...categoryCount.entries.map((entry) {
          final percentage = (entry.value / readings.length * 100).toStringAsFixed(1);
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Row(
              children: [
                pw.Container(
                  width: 15,
                  height: 15,
                  decoration: pw.BoxDecoration(
                    color: _getCategoryColor(entry.key),
                    borderRadius: pw.BorderRadius.circular(3),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Text('${entry.key.displayName}: ${entry.value} readings ($percentage%)'),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: 10),
        pw.Text(
          'Disclaimer: This report is for informational purposes only and should not be used as a substitute for professional medical advice. Always consult with your healthcare provider regarding your blood pressure readings.',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Generated by Blood Pressure App',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  PdfColor _getCategoryColor(BloodPressureCategory category) {
    switch (category) {
      case BloodPressureCategory.normal:
        return PdfColors.green;
      case BloodPressureCategory.elevated:
        return PdfColors.orange;
      case BloodPressureCategory.hypertensionStage1:
        return PdfColors.deepOrange;
      case BloodPressureCategory.hypertensionStage2:
        return PdfColors.red;
      case BloodPressureCategory.hypertensiveCrisis:
        return PdfColors.purple;
    }
  }

  Map<String, dynamic> _calculateStatistics(List<BloodPressureReading> readings) {
    if (readings.isEmpty) {
      return {
        'totalReadings': 0,
        'avgSystolic': 0,
        'avgDiastolic': 0,
        'avgPulse': 0,
      };
    }

    final totalSystolic = readings.fold<int>(0, (sum, reading) => sum + reading.systolic);
    final totalDiastolic = readings.fold<int>(0, (sum, reading) => sum + reading.diastolic);
    final totalPulse = readings.fold<int>(0, (sum, reading) => sum + reading.pulse);

    return {
      'totalReadings': readings.length,
      'avgSystolic': (totalSystolic / readings.length).round(),
      'avgDiastolic': (totalDiastolic / readings.length).round(),
      'avgPulse': (totalPulse / readings.length).round(),
    };
  }

  Future<void> shareReport(File pdfFile) async {
    await Share.shareXFiles(
      [XFile(pdfFile.path)],
      text: 'Blood Pressure Report',
      subject: 'My Blood Pressure Report',
    );
  }

  Future<void> printReport(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => bytes,
    );
  }
}