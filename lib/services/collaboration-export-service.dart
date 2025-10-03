import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ugcworks/views/earnings-overview/earnings-overview-view-model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class CollaborationExportService {
  
  Future<void> exportEarningsEntries(List<EarningsEntryViewModelFields> entries, {
    String locale = 'en',
    String dateHeader = 'Date',
    String titleHeader = 'Title',
    String amountHeader = 'Amount',
    String shareText = 'Earnings as CSV',
    required BuildContext context,
  }) async {
    final dateFormatter = DateFormat.yMd(locale);
    final buffer = StringBuffer();
    buffer.writeln('$dateHeader,$titleHeader,$amountHeader');
    double total = 0;
    for (final e in entries) {
      buffer.writeln('${dateFormatter.format(e.date)},${e.title.replaceAll(',', ';')},${e.amount.toStringAsFixed(2)}');
      total += e.amount;
    }

    buffer.writeln(',,${total.toStringAsFixed(2)}');

    final tempDir = await getTemporaryDirectory();
    final now = DateTime.now();
    final fileName = 'einnahmen_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.csv';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(buffer.toString(), flush: true);

    // Get the screen size for better positioning
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    
    await Share.shareXFiles(
      [XFile(file.path)], 
      text: shareText,
      sharePositionOrigin: Rect.fromLTWH(
        screenSize.width / 2 - 50, 
        screenSize.height / 2 - 50, 
        100, 
        100
      ),
    );
  }

  Future<void> exportEarningsEntriesPdf(List<EarningsEntryViewModelFields> entries, {
    String locale = 'en',
    String dateHeader = 'Date',
    String titleHeader = 'Title',
    String amountHeader = 'Amount',
    String earningsTitle = 'Earnings',
    String sumLabel = 'Sum',
    String shareText = 'Earnings as PDF',
    required BuildContext context,
  }) async {
    final dateFormatter = DateFormat.yMd(locale);
    double total = 0;

    final pdf = pw.Document();
    final tableHeaders = [dateHeader, titleHeader, amountHeader];
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final tableRows = <pw.TableRow>[];
          
          // Header row
          tableRows.add(
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.grey300),
              children: tableHeaders.map(
                (header) => pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text(
                    header,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ).toList(),
            ),
          );
          
          // Data rows
          for (final e in entries) {
            total += e.amount;
            tableRows.add(
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(dateFormatter.format(e.date)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(e.title),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(e.amount.toStringAsFixed(2)),
                  ),
                ],
              ),
            );
          }
          
          // Sum row
          tableRows.add(
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text(''),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text(''),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text(
                    '$sumLabel: ${total.toStringAsFixed(2)}', 
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)
                  ),
                ),
              ],
            ),
          );
          
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                earningsTitle,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(3),
                  2: pw.FlexColumnWidth(2),
                },
                children: tableRows,
              ),
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

    // Get the screen size for better positioning
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    
    await Share.shareXFiles(
      [XFile(file.path)], 
      text: shareText,
      sharePositionOrigin: Rect.fromLTWH(
        screenSize.width / 2 - 50, 
        screenSize.height / 2 - 50, 
        100, 
        100
      ),
    );
  }
}