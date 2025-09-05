import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:collabflow/views/earnings-overview/earnings-overview-view-model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class CollaborationExportService {
  Future<void> exportEarningsEntries(List<EarningsEntryViewModelFields> entries) async {
    final dateFormatter = DateFormat('dd.MM.yyyy');
    final buffer = StringBuffer();
    buffer.writeln('Datum,Titel,Betrag');
    double total = 0;
    for (final e in entries) {
      final dateStr = dateFormatter.format(e.date);
      final title = e.title.replaceAll('"', '""');
      final amountStr = e.amount.toStringAsFixed(2);
      buffer.writeln('"$dateStr","$title",$amountStr');
      total += e.amount;
    }

    buffer.writeln(',,${total.toStringAsFixed(2)}');

    final tempDir = await getTemporaryDirectory();
    final now = DateTime.now();
    final fileName = 'einnahmen_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.csv';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(buffer.toString(), flush: true);

    await Share.shareXFiles([XFile(file.path)], text: 'Einnahmen als CSV');
  }

  Future<void> exportEarningsEntriesPdf(List<EarningsEntryViewModelFields> entries) async {
    final dateFormatter = DateFormat('dd.MM.yyyy');
    double total = 0;

    final pdf = pw.Document();
    final tableHeaders = ['Datum', 'Titel', 'Betrag'];
    final dataRows = <List<String>>[];
    for (final e in entries) {
      total += e.amount;
      dataRows.add([
        dateFormatter.format(e.date),
        e.title,
        e.amount.toStringAsFixed(2),
      ]);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Text('Einnahmen', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.TableHelper.fromTextArray(
                headers: tableHeaders,
                data: dataRows,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(5),
                  2: const pw.FlexColumnWidth(2),
                },
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Summe: ${total.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                ],
              )
            ],
          );
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final now = DateTime.now();
    final fileName = 'einnahmen_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.pdf';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(await pdf.save(), flush: true);

    await Share.shareXFiles([XFile(file.path)], text: 'Einnahmen als PDF');
  }
}


