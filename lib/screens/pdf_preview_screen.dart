// pdf_preview_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:io';

class PdfPreviewScreen extends StatelessWidget {
  final File pdfFile;

  const PdfPreviewScreen({Key? key, required this.pdfFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debug: Print the file path and size
    print('PDF file path: ${pdfFile.path}');
    print('PDF file size: ${pdfFile.lengthSync()} bytes');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PDF Report',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.download),
        //     onPressed: () async {
        //       // Save the PDF to the device's download folder
        //       final directory = await getApplicationDocumentsDirectory();
        //       final path = '${directory.path}/patient_report.pdf';
        //       await pdfFile.copy(path);
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //           content: Text('PDF saved to $path'),
        //           duration: Duration(minutes: 2),
        //         ),
        //       );
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.email),
        //     onPressed: () async {
        //       // Send the PDF via email
        //       final Email email = Email(
        //         body: 'Please find the attached patient report.',
        //         subject: 'Patient Report',
        //         recipients: ['doctor@example.com'],
        //         attachmentPaths: [pdfFile.path],
        //       );
        //       await FlutterEmailSender.send(email);
        //     },
        //   ),
        // ],
      ),
      body: PdfPreview(
        build: (format) => pdfFile.readAsBytes(),
      ),
    );
  }
}
