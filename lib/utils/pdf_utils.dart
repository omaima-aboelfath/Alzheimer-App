// // // pdf_utils.dart
// // import 'package:flutter/services.dart';
// // import 'package:pdf/widgets.dart' as pw;

// // class PdfUtils {
// //   static Future<pw.Document> generatePdfReport(
// //       Map<String, dynamic> data) async {
// //     final pdf = pw.Document();
// // // Load the Roboto font from assets
// //     final ByteData robotoData =
// //         await rootBundle.load('assets/fonts/Roboto-VariableFont_wdth,wght.ttf');
// //     // Convert ByteData to Uint8List
// //     final Uint8List robotoBytes = robotoData.buffer.asUint8List();
// //     // Convert Uint8List to ByteData
// //     final ByteData robotoByteData = ByteData.view(robotoBytes.buffer);
// //     // Create a PDF font from the loaded font
// //     final ttf = pw.Font.ttf(robotoByteData);
// //     pdf.addPage(
// //       pw.Page(
// //         build: (context) {
// //           return pw.Column(
// //             crossAxisAlignment: pw.CrossAxisAlignment.start,
// //             children: [
// //               pw.Header(
// //                 level: 0,
// //                 child: pw.Text('Patient Report',
// //                     style: pw.TextStyle(font: ttf, fontSize: 24)),
// //               ),
// //               pw.SizedBox(height: 20),
// //               pw.Text('Patient Name: ${data['patientName'] ?? 'N/A'}',
// //                   style: pw.TextStyle(font: ttf, fontSize: 18)),
// //               pw.Text('Total Tasks: ${data['totalTasks'] ?? 'N/A'}',
// //                   style: pw.TextStyle(font: ttf, fontSize: 18)),
// //               pw.Text('Completed Tasks: ${data['completedTasks'] ?? 'N/A'}',
// //                   style: pw.TextStyle(font: ttf, fontSize: 18)),
// //               pw.Text('Incomplete Tasks: ${data['incompleteTasks'] ?? 'N/A'}',
// //                   style: pw.TextStyle(font: ttf, fontSize: 18)),
// //               pw.SizedBox(height: 20),
// //               // pw.Header(
// //               //   level: 1,
// //               //   child: pw.Text('Delay Forecast',
// //               //       style: pw.TextStyle(font: ttf, fontSize: 20)),
// //               // ),
// //               // pw.Text('Forecast Data: ${data['forecastData']}',
// //               //     style: pw.TextStyle(font: ttf, fontSize: 18)),
// //               // pw.Header(
// //               //   level: 1,
// //               //   child: pw.Text(
// //               //     'Delay Forecast',
// //               //     style: pw.TextStyle(font: ttf, fontSize: 20),
// //               //   ),
// //               // ),
// //               // if (data['forecastData'] != null)
// //               //   pw.Table(
// //               //     border: pw.TableBorder.all(),
// //               //     children: [
// //               //       pw.TableRow(
// //               //         children: [
// //               //           pw.Text('Day',
// //               //               style: pw.TextStyle(font: ttf, fontSize: 16)),
// //               //           pw.Text('Forecasted Delay (minutes)',
// //               //               style: pw.TextStyle(font: ttf, fontSize: 16)),
// //               //         ],
// //               //       ),
// //               //       for (var entry
// //               //           in (data['forecastData'] as Map<String, dynamic>)
// //               //               .entries)
// //               //         pw.TableRow(
// //               //           children: [
// //               //             pw.Text(entry.key,
// //               //                 style: pw.TextStyle(font: ttf, fontSize: 14)),
// //               //             pw.Text(entry.value.toString(),
// //               //                 style: pw.TextStyle(font: ttf, fontSize: 14)),
// //               //           ],
// //               //         ),
// //               //     ],
// //               //   ),
// //               // pw.SizedBox(height: 20),
// //               pw.Header(
// //                 level: 1,
// //                 child: pw.Text('Recommendations',
// //                     style: pw.TextStyle(font: ttf, fontSize: 20)),
// //               ),
// //               pw.Text('Recommendations: ${data['recommendations'] ?? 'N/A'}',
// //                   style: pw.TextStyle(font: ttf, fontSize: 18)),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //     // Debug: Print the PDF content
// //     final bytes = await pdf.save();
// //     print('PDF generated with ${bytes.length} bytes');
// //     return pdf;
// //   }

// //   // static Future<pw.Document> generatePdfReport(
// //   //     Map<String, dynamic> data) async {
// //   //   final pdf = pw.Document();
// //   //   // Load a Google Font (e.g., Roboto)
// //   //   // final robotoData = await GoogleFonts.roboto().fontData;
// //   //   // final ttf = pw.Font.ttf(robotoData!);

// //   //   // Load the Roboto font as ByteData
// //   //   final ByteData robotoData =
// //   //       await rootBundle.load('assets/fonts/Roboto-VariableFont_wdth,wght.ttf');

// //   //   // Convert ByteData to Uint8List
// //   //   final Uint8List robotoBytes = robotoData.buffer.asUint8List();

// //   //   // Convert Uint8List to ByteData
// //   //   final ByteData robotoByteData = ByteData.view(robotoBytes.buffer);

// //   //   // Create a PDF font from the loaded font
// //   //   final ttf = pw.Font.ttf(robotoByteData);

// //   //   pdf.addPage(
// //   //     pw.Page(
// //   //       build: (context) {
// //   //         return pw.Center(
// //   //           child: pw.Text('Hello, this is a test PDF!',
// //   //               style: pw.TextStyle(font: ttf)),
// //   //         );
// //   //       },
// //   //     ),
// //   //   );
// //   //   return pdf;
// //   // }

// //   // static Future<File> savePdfToFile(pw.Document pdf) async {
// //   //   final directory = await getApplicationDocumentsDirectory();
// //   //   final path = '${directory.path}/patient_report.pdf';
// //   //   final file = File(path);
// //   //   // Save the PDF to the file
// //   //   final bytes = await pdf.save();
// //   //   await file.writeAsBytes(await pdf.save());
// //   //   // Debug: Print the file path and size
// //   //   print('PDF saved to: $path');
// //   //   print('File size: ${file.lengthSync()} bytes');
// //   //   return file;
// //   // }

// // }

// //2
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:graduation_app/utils/date_time_utils.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';

// class PdfUtils {
//   // static Future<pw.Document> generatePdfReport(Map<String, dynamic> data) async {
//   //   final pdf = pw.Document();

//   //   // Load the Roboto font from assets
//   //   final ByteData robotoData = await rootBundle.load('assets/fonts/Roboto-VariableFont_wdth,wght.ttf');
//   //   final Uint8List robotoBytes = robotoData.buffer.asUint8List();
//   //   final ByteData robotoByteData = ByteData.view(robotoBytes.buffer);
//   //   final ttf = pw.Font.ttf(robotoByteData);

//   //   // Load the scatter plot image
//   //   final scatterPlotPath = data['scatter_plot_path'];
//   //   final scatterPlotImage = scatterPlotPath != null ? pw.MemoryImage(File(scatterPlotPath).readAsBytesSync()) : null;

//   //   pdf.addPage(
//   //     pw.Page(
//   //       build: (context) {
//   //         return pw.Column(
//   //           crossAxisAlignment: pw.CrossAxisAlignment.start,
//   //           children: [
//   //             pw.Header(
//   //               level: 0,
//   //               child: pw.Text('Patient Report', style: pw.TextStyle(font: ttf, fontSize: 24)),
//   //             ),
//   //             pw.SizedBox(height: 20),
//   //             pw.Text('Patient Name: ${data['patientName'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
//   //             pw.Text('Total Tasks: ${data['totalTasks'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
//   //             pw.Text('Completed Tasks: ${data['completedTasks'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
//   //             pw.Text('Incomplete Tasks: ${data['incompleteTasks'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
//   //             pw.SizedBox(height: 20),
//   //             pw.Header(
//   //               level: 1,
//   //               child: pw.Text('Recommendations', style: pw.TextStyle(font: ttf, fontSize: 20)),
//   //             ),
//   //             pw.Text('Recommendations: ${data['recommendations'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
//   //             pw.SizedBox(height: 20),
//   //             if (scatterPlotImage != null)
//   //               pw.Header(
//   //                 level: 1,
//   //                 child: pw.Text('Task Delays Over Time', style: pw.TextStyle(font: ttf, fontSize: 20)),
//   //               ),
//   //             if (scatterPlotImage != null)
//   //               pw.Center(
//   //                 child: pw.Image(scatterPlotImage),
//   //               ),
//   //           ],
//   //         );
//   //       },
//   //     ),
//   //   );

//   //   // Debug: Print the PDF content
//   //   final bytes = await pdf.save();
//   //   print('PDF generated with ${bytes.length} bytes');
//   //   return pdf;
//   // }

//   static Future<File> savePdfToFile(pw.Document pdf) async {
//     final bytes = await pdf.save();
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/patient_report.pdf');
//     await file.writeAsBytes(bytes);
//     return file;
//   }

// // correct but the formatt
// //   static Future<pw.Document> generatePdfReport(Map<String, dynamic> data) async {
// //   final pdf = pw.Document();

// //   // Load the Roboto font from assets
// //   final ByteData robotoData = await rootBundle.load('assets/fonts/Roboto-VariableFont_wdth,wght.ttf');
// //   final Uint8List robotoBytes = robotoData.buffer.asUint8List();
// //   final ByteData robotoByteData = ByteData.view(robotoBytes.buffer);
// //   final ttf = pw.Font.ttf(robotoByteData);

// //   // Load the scatter plot image
// //   final scatterPlotPath = data['scatter_plot_path'];
// //   final scatterPlotImage = scatterPlotPath != null ? pw.MemoryImage(File(scatterPlotPath).readAsBytesSync()) : null;

// //   pdf.addPage(
// //     pw.Page(
// //       build: (context) {
// //         return pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //             pw.Header(
// //               level: 0,
// //               child: pw.Text('Patient Report', style: pw.TextStyle(font: ttf, fontSize: 24)),
// //             ),
// //             pw.SizedBox(height: 20),
// //             pw.Text('Patient Name: ${data['patientName'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
// //             pw.Text('Total Tasks: ${data['totalTasks'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
// //             pw.Text('Completed Tasks: ${data['completedTasks'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
// //             pw.Text('Incomplete Tasks: ${data['incompleteTasks'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
// //             pw.Text('Delayed Tasks: ${data['delayedTasks'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
// //             pw.Text('Average Delay: ${data['averageDelay']?.toStringAsFixed(2) ?? 'N/A'} minutes', style: pw.TextStyle(font: ttf, fontSize: 18)),
// //             pw.SizedBox(height: 20),
// //             pw.Header(
// //               level: 1,
// //               child: pw.Text('Most Delayed Tasks', style: pw.TextStyle(font: ttf, fontSize: 20)),
// //             ),
// //             for (final entry in (data['mostDelayedTasks'] ?? {}).entries)
// //               pw.Text('${entry.key}: ${entry.value.toStringAsFixed(2)} minutes', style: pw.TextStyle(font: ttf, fontSize: 16)),
// //             pw.SizedBox(height: 20),
// //             pw.Header(
// //               level: 1,
// //               child: pw.Text('Time of Day Delays', style: pw.TextStyle(font: ttf, fontSize: 20)),
// //             ),
// //             for (final entry in (data['timeOfDayDelays'] ?? {}).entries)
// //               pw.Text('Hour ${entry.key}: ${entry.value} delays', style: pw.TextStyle(font: ttf, fontSize: 16)),
// //             pw.SizedBox(height: 20),
// //             pw.Header(
// //               level: 1,
// //               child: pw.Text('Recommendations', style: pw.TextStyle(font: ttf, fontSize: 20)),
// //             ),
// //             pw.Text('Recommendations: ${data['recommendations'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
// //             pw.SizedBox(height: 20),
// //             if (scatterPlotImage != null)
// //               pw.Header(
// //                 level: 1,
// //                 child: pw.Text('Task Delays Over Time', style: pw.TextStyle(font: ttf, fontSize: 20)),
// //               ),
// //             if (scatterPlotImage != null)
// //               pw.Center(
// //                 child: pw.Image(scatterPlotImage),
// //               ),
// //           ],
// //         );
// //       },
// //     ),
// //   );

// //   // Debug: Print the PDF content
// //   final bytes = await pdf.save();
// //   print('PDF generated with ${bytes.length} bytes');
// //   return pdf;
// // }

//   static Future<pw.Document> generatePdfReport(
//       Map<String, dynamic> data) async {
//     final pdf = pw.Document();

//     // Load the Roboto font from assets
//     final ByteData robotoData =
//         await rootBundle.load('assets/fonts/Roboto-VariableFont_wdth,wght.ttf');
//     final Uint8List robotoBytes = robotoData.buffer.asUint8List();
//     final ByteData robotoByteData = ByteData.view(robotoBytes.buffer);
//     final ttf = pw.Font.ttf(robotoByteData);
//     // Load the scatter plot image
//     final scatterPlotPath = data['scatter_plot_path'];
//     final scatterPlotImage = scatterPlotPath != null
//         ? pw.MemoryImage(File(scatterPlotPath).readAsBytesSync())
//         : null;

//     pdf.addPage(
//       pw.Page(
//         build: (context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Header(
//                 level: 0,
//                 child: pw.Text('Patient Report',
//                     style: pw.TextStyle(font: ttf, fontSize: 24)),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Text('Patient Name: ${data['patientName'] ?? 'N/A'}',
//                   style: pw.TextStyle(font: ttf, fontSize: 18)),
//               pw.Text('Total Tasks: ${data['totalTasks'] ?? 'N/A'}',
//                   style: pw.TextStyle(font: ttf, fontSize: 18)),
//               pw.Text('Completed Tasks: ${data['completedTasks'] ?? 'N/A'}',
//                   style: pw.TextStyle(font: ttf, fontSize: 18)),
//               pw.Text('Incomplete Tasks: ${data['incompleteTasks'] ?? 'N/A'}',
//                   style: pw.TextStyle(font: ttf, fontSize: 18)),
//               pw.Text('Delayed Tasks: ${data['delayedTasks'] ?? 'N/A'}',
//                   style: pw.TextStyle(font: ttf, fontSize: 18)),
//               pw.Text(
//                   'Average Delay: ${DateTimeUtils.formatDelay(data['averageDelay'] ?? Duration.zero)}',
//                   style: pw.TextStyle(font: ttf, fontSize: 18)),
//               pw.SizedBox(height: 20),
//               pw.Header(
//                 level: 1,
//                 child: pw.Text('Most Delayed Tasks',
//                     style: pw.TextStyle(font: ttf, fontSize: 20)),
//               ),
//               for (final entry in (data['mostDelayedTasks'] ?? {}).entries)
//                 pw.Text(
//                     '${entry.key}: ${DateTimeUtils.formatDelay(entry.value)}',
//                     style: pw.TextStyle(font: ttf, fontSize: 16)),
//               pw.SizedBox(height: 20),
//               pw.Header(
//                 level: 1,
//                 child: pw.Text('Time of Day Delays',
//                     style: pw.TextStyle(font: ttf, fontSize: 20)),
//               ),
//               for (final entry in (data['timeOfDayDelays'] ?? {}).entries)
//                 pw.Text(
//                     '${entry.key % 12} ${entry.key < 12 ? 'AM' : 'PM'}: ${entry.value} delays',
//                     style: pw.TextStyle(font: ttf, fontSize: 16)),
//               pw.SizedBox(height: 20),
//               if (scatterPlotImage != null)
//                 pw.Header(
//                   level: 1,
//                   child: pw.Text('Task Delays Over Time',
//                       style: pw.TextStyle(font: ttf, fontSize: 20)),
//                 ),
//               if (scatterPlotImage != null)
//                 pw.Center(
//                   child: pw.Image(scatterPlotImage),
//                 ),
//             ],
//           );
//         },
//       ),
//     );

//     // Debug: Print the PDF content
//     final bytes = await pdf.save();
//     print('PDF generated with ${bytes.length} bytes');
//     return pdf;
//   }
// }

import 'package:flutter/material.dart';
import 'package:graduation_app/model/api_manager.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/utils/date_time_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class PdfUtils {
  // static Future<File> generatePdfReport(Map<String, dynamic> data) async {
  //   final pdf = pw.Document();

  //   // Load the Roboto font from assets
  //   final ByteData robotoData = await rootBundle.load('assets/fonts/Roboto-VariableFont_wdth,wght.ttf');
  //   final Uint8List robotoBytes = robotoData.buffer.asUint8List();
  //   final ByteData robotoByteData = ByteData.view(robotoBytes.buffer);
  //   final ttf = pw.Font.ttf(robotoByteData);

  //   // Load the scatter plot image
  //   final scatterPlotPath = data['scatter_plot_path'];
  //   final scatterPlotImage = scatterPlotPath != null
  //       ? pw.MemoryImage(File(scatterPlotPath).readAsBytesSync())
  //       : null;

  //   pdf.addPage(
  //     pw.Page(
  //       build: (context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Header(
  //               level: 0,
  //               child: pw.Text('Patient Report', style: pw.TextStyle(font: ttf, fontSize: 24)),
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Text('Patient Name: ${data['patientName'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.Text('Total Tasks: ${data['totalTasks'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.Text('Completed Tasks: ${data['completedTasks'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.Text('Incomplete Tasks: ${data['incompleteTasks'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.Text('Delayed Tasks: ${data['delayedTasks'] ?? 'N/A'}', style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.Text('Average Delay: ${DateTimeUtils.formatDelay(data['averageDelay'] ?? Duration.zero)}', style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.SizedBox(height: 20),
  //             pw.Header(
  //               level: 1,
  //               child: pw.Text('Most Delayed Tasks', style: pw.TextStyle(font: ttf, fontSize: 20)),
  //             ),
  //             for (final entry in (data['mostDelayedTasks'] ?? {}).entries)
  //               pw.Text('${entry.key}: ${DateTimeUtils.formatDelay(entry.value)}', style: pw.TextStyle(font: ttf, fontSize: 16)),
  //             pw.SizedBox(height: 20),
  //             pw.Header(
  //               level: 1,
  //               child: pw.Text('Time of Day Delays', style: pw.TextStyle(font: ttf, fontSize: 20)),
  //             ),
  //             for (final entry in (data['timeOfDayDelays'] ?? {}).entries)
  //               pw.Text('${entry.key % 12} ${entry.key < 12 ? 'AM' : 'PM'}: ${entry.value} delays', style: pw.TextStyle(font: ttf, fontSize: 16)),
  //             pw.SizedBox(height: 20),
  //             if (scatterPlotImage != null)
  //               pw.Header(
  //                 level: 1,
  //                 child: pw.Text('Task Delays Over Time', style: pw.TextStyle(font: ttf, fontSize: 20)),
  //               ),
  //             if (scatterPlotImage != null)
  //               pw.Center(
  //                 child: pw.Image(scatterPlotImage),
  //               ),
  //           ],
  //         );
  //       },
  //     ),
  //   );

  //   // Save the PDF to a file
  //   final bytes = await pdf.save();
  //   final file = File('${(await getTemporaryDirectory()).path}/report.pdf');
  //   await file.writeAsBytes(bytes);
  //   return file;
  //   // return pdf;
  // }

  ///22 correct with no data
  // static Future<File> generatePdfReport(Map<String, dynamic> data) async {
  //   final pdf = pw.Document();

  //   // Load the Roboto font from assets
  //   final ByteData robotoData =
  //       await rootBundle.load('assets/fonts/Roboto-VariableFont_wdth,wght.ttf');
  //   final Uint8List robotoBytes = robotoData.buffer.asUint8List();
  //   final ByteData robotoByteData = ByteData.view(robotoBytes.buffer);
  //   final ttf = pw.Font.ttf(robotoByteData);
  //   // Download scatter plot image
  //   final scatterPlotUrl = data['scatter_plot_url'];
  //   File? scatterPlotFile;
  //   if (scatterPlotUrl != null) {
  //     scatterPlotFile = await ApiManager.downloadScatterPlot(scatterPlotUrl);
  //   }
  //   // Load the scatter plot image
  //   final scatterPlotImage = scatterPlotFile != null
  //       ? pw.MemoryImage(scatterPlotFile.readAsBytesSync())
  //       : null;

  //   pdf.addPage(
  //     pw.Page(
  //       build: (context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Header(
  //               level: 0,
  //               child: pw.Text('Patient Report',
  //                   style: pw.TextStyle(font: ttf, fontSize: 24)),
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Text('Patient Name: ${data['patientName'] ?? 'N/A'}',
  //                 style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.Text('Total Tasks: ${data['totalTasks'] ?? 'N/A'}',
  //                 style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.Text('Completed Tasks: ${data['completedTasks'] ?? 'N/A'}',
  //                 style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.Text('Incomplete Tasks: ${data['incompleteTasks'] ?? 'N/A'}',
  //                 style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.Text('Delayed Tasks: ${data['delayedTasks'] ?? 'N/A'}',
  //                 style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.Text(
  //                 'Average Delay: ${DateTimeUtils.formatDelay(data['averageDelay'] ?? Duration.zero)}',
  //                 style: pw.TextStyle(font: ttf, fontSize: 18)),
  //             pw.SizedBox(height: 20),
  //             pw.Header(
  //               level: 1,
  //               child: pw.Text('Most Delayed Tasks',
  //                   style: pw.TextStyle(font: ttf, fontSize: 20)),
  //             ),
  //             for (final entry in (data['mostDelayedTasks'] ?? {}).entries)
  //               pw.Text(
  //                   '${entry.key}: ${DateTimeUtils.formatDelay(entry.value)}',
  //                   style: pw.TextStyle(font: ttf, fontSize: 16)),
  //             pw.SizedBox(height: 20),
  //             pw.Header(
  //               level: 1,
  //               child: pw.Text('Time of Day Delays',
  //                   style: pw.TextStyle(font: ttf, fontSize: 20)),
  //             ),
  //             for (final entry in (data['timeOfDayDelays'] ?? {}).entries)
  //               pw.Text(
  //                   '${entry.key % 12} ${entry.key < 12 ? 'AM' : 'PM'}: ${entry.value} delays',
  //                   style: pw.TextStyle(font: ttf, fontSize: 16)),
  //             pw.SizedBox(height: 20),
  //             if (scatterPlotImage != null)
  //               pw.Header(
  //                 level: 1,
  //                 child: pw.Text('Task Delays Over Time',
  //                     style: pw.TextStyle(font: ttf, fontSize: 20)),
  //               ),
  //             if (scatterPlotImage != null)
  //               pw.Center(
  //                 child: pw.Image(scatterPlotImage),
  //               ),
  //           ],
  //         );
  //       },
  //     ),
  //   );

  //   // print('PDF generated with ${bytes.length} bytes');
  //   // Save the PDF to a file
  //   final bytes = await pdf.save();
  //   final directory = await getTemporaryDirectory();
  //   final file = File('${directory.path}/report.pdf');
  //   await file.writeAsBytes(bytes);
  //   return file;
  // }

  //333 /corrrecttt******
//   static Future<File> generatePdfReport(
//       Map<String, dynamic> data, String patientName) async {
//     final pdf = pw.Document();

//     // Convert most delayed tasks from minutes to Duration and format them
//     final mostDelayedTasks =
//         (data['most_delayed_tasks'] as Map<String, dynamic>?)
//                 ?.map((key, value) {
//               final delayMinutes = value is double ? value : 0.0;
//               final formattedValue = DateTimeUtils.formatDelay(
//                   Duration(minutes: delayMinutes.toInt()));
//               return MapEntry(key, formattedValue);
//             }) ??
//             {};

// // Sort most delayed tasks in decreasing order of delay
//     final sortedMostDelayedTasks = Map.fromEntries(
//       mostDelayedTasks.entries.toList()
//         ..sort((a, b) {
//           final delayA = double.tryParse(a.value.split(' ')[0]) ?? 0.0;
//           final delayB = double.tryParse(b.value.split(' ')[0]) ?? 0.0;
//           return delayB.compareTo(delayA); // Sort in descending order
//         }),
//     );
// // Convert average delay from minutes to Duration and format it
//     final averageDelayMinutes =
//         data['average_delay'] is double ? data['average_delay'] as double : 0.0;
//     final averageDelay = DateTimeUtils.formatDelay(
//         Duration(minutes: averageDelayMinutes.toInt()));

//     // Format the time of day delays in 12-hour system
//     final timeOfDayDelays = (data['time_of_day_delays']
//                 as Map<String, dynamic>?)
//             ?.map((key, value) {
//           final hour =
//               int.tryParse(key) ?? 0; // Convert key to hour (e.g., "7" -> 7)
//           final period = hour >= 12 ? 'PM' : 'AM'; // Determine AM/PM
//           final hour12 =
//               hour % 12 == 0 ? 12 : hour % 12; // Convert to 12-hour format
//           final formattedKey = '$hour12 $period'; // Format as "7 AM" or "2 PM"
//           return MapEntry(formattedKey, value);
//         }) ??
//         {};

//     // Load the image from assets
//     // final image = pw.MemoryImage(
//     //   (await rootBundle.load('charts/pharos2.jpg')).buffer.asUint8List(),
//     // );
//     ///laassttttttt**
//     // final pngBytes = await rootBundle
//     //     .load('charts/scatter_plot_ckiBJlG8YWRubuJOD0WBLKfWEz42.png');
//     // final image = img.decodePng(pngBytes.buffer.asUint8List());
//     // final jpegBytes = img.encodeJpg(image!);
//     // final imagePw = pw.MemoryImage(
//     //   jpegBytes,
//     // );

//     // Add content to the PDF
//     pdf.addPage(
//       pw.Page(
//         build: (context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Header(
//                 level: 0,
//                 child: pw.Text('Patient Report',
//                     style: pw.TextStyle(fontSize: 24)),
//               ),
//               pw.SizedBox(height: 20),
//               // pw.Text('Patient Name: ${data['patient_name'] ?? 'N/A'}',
//               pw.Text('Patient Name: ${patientName}',
//                   style: pw.TextStyle(fontSize: 18)),
//               pw.Text('Total Tasks: ${data['total_tasks'] ?? 'N/A'}',
//                   style: pw.TextStyle(fontSize: 18)),
//               pw.Text('Completed Tasks: ${data['completed_tasks'] ?? 'N/A'}',
//                   style: pw.TextStyle(fontSize: 18)),
//               pw.Text('Incomplete Tasks: ${data['incomplete_tasks'] ?? 'N/A'}',
//                   style: pw.TextStyle(fontSize: 18)),
//               pw.Text('Delayed Tasks: ${data['delayed_tasks'] ?? 'N/A'}',
//                   style: pw.TextStyle(fontSize: 18)),
//               pw.Text('Average Delay: $averageDelay',
//                   style: pw.TextStyle(fontSize: 18)),
//               pw.SizedBox(height: 20),
//               pw.Header(
//                 level: 1,
//                 child: pw.Text('Most Delayed Tasks',
//                     style: pw.TextStyle(fontSize: 20)),
//               ),
//               for (final entry in sortedMostDelayedTasks.entries)
//                 pw.Text('${entry.key}: ${entry.value}',
//                     style: pw.TextStyle(fontSize: 16)),
//               pw.SizedBox(height: 20),
//               pw.Header(
//                 level: 1,
//                 child: pw.Text('Time of Day Delays',
//                     style: pw.TextStyle(fontSize: 20)),
//               ),
//               for (final entry in timeOfDayDelays.entries)
//                 pw.Text('${entry.key}: ${entry.value} delays',
//                     style: pw.TextStyle(fontSize: 16)),
//               // pw.Image(image), // Display the image
//               // pw.Image(imagePw), // Display the image
//             ],
//           );
//         },
//       ),
//     );

//     // Save the PDF to a file
//     final bytes = await pdf.save();
//     final directory = await getTemporaryDirectory();
//     final file = File('${directory.path}/report.pdf');
//     await file.writeAsBytes(bytes);
//     return file;
//   }

  static String formatDelayHumanReadable(int delaySeconds) {
    final days = delaySeconds ~/ (24 * 60 * 60);
    final hours = (delaySeconds % (24 * 60 * 60)) ~/ (60 * 60);
    final minutes = (delaySeconds % (60 * 60)) ~/ 60;
    final seconds = delaySeconds % 60;

    final parts = [
      if (days > 0) '$days ${days == 1 ? 'day' : 'days'}',
      if (hours > 0) '$hours ${hours == 1 ? 'hour' : 'hours'}',
      if (minutes > 0) '$minutes ${minutes == 1 ? 'minute' : 'minutes'}',
      if (seconds > 0) '$seconds ${seconds == 1 ? 'second' : 'seconds'}',
    ];

    return parts.join(' and ');
  }

  static Future<File> generatePdfReport(
      Map<String, dynamic> data, String patientName) async {
    final pdf = pw.Document();

    // Convert most delayed tasks from minutes to Duration and format them
    final mostDelayedTasks =
        (data['mostDelayedTasks'] as Map<String, dynamic>?)?.map((key, value) {
              final delayMinutes =
                  double.tryParse(value.toString()) ?? 0.0; // Convert to double
              final delaySeconds =
                  (delayMinutes * 60).toInt(); // Convert minutes to seconds
              // final formattedValue = DateTimeUtils.formatDelay(
              //     Duration(minutes: delayMinutes.toInt())); // Format delay
              final formattedValue =
                  formatDelayHumanReadable(delaySeconds); // Format delay
              return MapEntry(key, formattedValue);
            }) ??
            {};

    // Sort most delayed tasks in decreasing order of delay
    final sortedMostDelayedTasks = Map.fromEntries(
      mostDelayedTasks.entries.toList()
        ..sort((a, b) {
          final delayA = double.tryParse(a.value.split(' ')[0]) ??
              0.0; // Extract delay value
          final delayB = double.tryParse(b.value.split(' ')[0]) ??
              0.0; // Extract delay value
          return delayB.compareTo(delayA); // Sort in descending order
        }),
    );

    // Convert average delay from minutes to Duration and format it
    final averageDelayMinutes =
        double.tryParse(data['averageDelay'].toString()) ??
            0.0; // Convert to double
    final averageDelay = DateTimeUtils.formatDelay(
        Duration(minutes: averageDelayMinutes.toInt())); // Format delay

    // Format the time of day delays in 12-hour system
    final timeOfDayDelays = (data['timeOfDayDelays'] as Map<String, dynamic>?)
            ?.map((key, value) {
          final hour =
              int.tryParse(key) ?? 0; // Convert key to hour (e.g., "7" -> 7)
          final period = hour >= 12 ? 'PM' : 'AM'; // Determine AM/PM
          final hour12 =
              hour % 12 == 0 ? 12 : hour % 12; // Convert to 12-hour format
          final formattedKey = '$hour12 $period'; // Format as "7 AM" or "2 PM"
          return MapEntry(
              formattedKey, value.toString()); // Ensure value is a String
        }) ??
        {};

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Patient Report',
                    style: pw.TextStyle(fontSize: 24)),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Patient Name: $patientName',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Total Tasks: ${data['totalTasks'] ?? 'N/A'}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Completed Tasks: ${data['completedTasks'] ?? 'N/A'}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Incomplete Tasks: ${data['incompleteTasks'] ?? 'N/A'}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Delayed Tasks: ${data['delayedTasks'] ?? 'N/A'}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Average Delay: $averageDelay',
                  style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text('Most Delayed Tasks',
                    style: pw.TextStyle(fontSize: 20)),
              ),
              for (final entry in sortedMostDelayedTasks.entries)
                pw.Text('${entry.key}: ${entry.value}',
                    style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text('Time of Day Delays',
                    style: pw.TextStyle(fontSize: 20)),
              ),
              for (final entry in timeOfDayDelays.entries)
                pw.Text('${entry.key}: ${entry.value} delays',
                    style: pw.TextStyle(fontSize: 16)),
            ],
          );
        },
      ),
    );

    // Save the PDF to a file
    final bytes = await pdf.save();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/report.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }
}
