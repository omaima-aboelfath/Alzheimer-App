// // webview_flutter - android only
// /*
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import '../../model/api_manager.dart';

// class PlotlyChartScreen extends StatefulWidget {
//   final String userId;

//   const PlotlyChartScreen({Key? key, required this.userId}) : super(key: key);

//   @override
//   _PlotlyChartScreenState createState() => _PlotlyChartScreenState();
// }

// class _PlotlyChartScreenState extends State<PlotlyChartScreen> {
//   // late final WebViewController _controller;
//   bool isLoading = true;
//   String? chartJson;
//   String errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchChart();
//   }

//   Future<void> fetchChart() async {
//     try {
//       final chartData = await ApiManager.fetchDelayVisualizationChart(widget.userId);
//       setState(() {
//         chartJson = chartData;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error loading chart: $e';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (errorMessage.isNotEmpty) {
//       return Scaffold(
//         body: Center(child: Text(errorMessage)),
//       );
//     }

//     // HTML content with embedded Plotly chart
//     final htmlContent = '''
//     <!DOCTYPE html>
//     <html>
//     <head>
//       <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
//     </head>
//     <body>
//       <div id="plotly-chart" style="width:100%;height:100%;"></div>
//       <script>
//         const data = $chartJson;
//         Plotly.newPlot('plotly-chart', data.data, data.layout);
//       </script>
//     </body>
//     </html>
//     ''';

//     return Scaffold(
//       appBar: AppBar(title: Text('Task Delays Visualization')),
//       body: WebViewWidget(
//         controller: WebViewController()
//           ..loadHtmlString(htmlContent)
//           ..setJavaScriptMode(JavaScriptMode.unrestricted),
//       ),
//     );
//   }
// }
// */

// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import '../../model/api_manager.dart';
// import 'dart:convert';

// class PlotlyChartScreen extends StatefulWidget {
//   final String userId;

//   const PlotlyChartScreen({Key? key, required this.userId}) : super(key: key);

//   @override
//   _PlotlyChartScreenState createState() => _PlotlyChartScreenState();
// }

// class _PlotlyChartScreenState extends State<PlotlyChartScreen> {
//   bool isLoading = true;
//   String? chartJson;
//   String errorMessage = '';
//   late InAppWebViewController _webViewController;

//   @override
//   void initState() {
//     super.initState();
//     fetchChart();
//   }

//   Future<void> fetchChart() async {
//     try {
//       final chartData =
//           await ApiManager.fetchDelayVisualizationChart(widget.userId);
//       setState(() {
//         chartJson = chartData;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error loading chart: $e';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (errorMessage.isNotEmpty) {
//       return Scaffold(
//         body: Center(child: Text(errorMessage)),
//       );
//     }

//     // HTML content with embedded Plotly chart
//     final htmlContent = '''
//     <!DOCTYPE html>
//     <html>
//     <head>
//       <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
//     </head>
//     <body>
//       <div id="plotly-chart" style="width:100%;height:100%;"></div>
//       <script>
//         const data = $chartJson;
//         Plotly.newPlot('plotly-chart', data.data, data.layout);
//       </script>
//     </body>
//     </html>
//     ''';

//     // Base64 encode the HTML content to embed it as a data URL
//     final encodedHtml = base64Encode(utf8.encode(htmlContent));

//     // Create a WebUri with a Data URL
//     final webUri = WebUri("data:text/html;base64,$encodedHtml");

//     return Scaffold(
//       appBar: AppBar(title: Text('Task Delays Visualization')),
//       body: Center(
//         child: InAppWebView(
//           initialUrlRequest: URLRequest(url: webUri),
//           onWebViewCreated: (InAppWebViewController webViewController) {
//             _webViewController = webViewController;
//           },
//         ),
//       ),
//     );
//   }
// }
