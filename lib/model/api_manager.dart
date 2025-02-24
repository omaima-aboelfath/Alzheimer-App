import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../utils/firebase_utils.dart';

class ApiManager {
  static const String baseUrl = 'http://10.0.2.2:5000'; // Android Emulator
  // static const String baseUrl = 'http://127.0.0.1:5000'; // ( OR http://localhost:5000)Web or Physical Device (iOS/Android)

  /// General method to perform GET requests
  static Future<Map<String, dynamic>> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to load data: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error during GET request: $e');
    }
  }

  /// General method to perform POST requests
  static Future<Map<String, dynamic>> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to post data: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error during POST request: $e');
    }
  }

  /// Method for fetching task summary chart //last
  // static Future<String> fetchTaskSummaryChart(String patientId) async {
  //   final response = await getRequest('users/$patientId/tasks-summary-chart');
  //   if (response.containsKey('chart_url')) {
  //     return response['chart_url'];
  //   } else {
  //     throw Exception('Chart URL missing in response');
  //   }
  // }

  /// Fetch delay visualization chart //last for plotly
  // static Future<String> fetchDelayVisualizationChart(String userId) async {
  //   final response = await getRequest('users/$userId/visualize-delays');
  //   if (response.containsKey('chart')) {
  //     return response['chart']; // Chart JSON data
  //   } else {
  //     throw Exception('Chart data missing in response');
  //   }
  // }

  // Fetch forecast data for patient delays
  // static Future<Map<String, dynamic>> fetchForecastDelays(String userId) async {
  //   final forecastData = await getRequest('users/$userId/forecast');
  //   return forecastData;
  // }
  // Fetch forecast data for patient delays
  // Fetch forecast data for patient delays

// static Future<List<Map<String, dynamic>>> fetchForecastDelays(String userId) async {
//   final forecastData = await getRequest('users/$userId/forecast');
//   // Ensure the response is a Map, and access the list of forecast data
//   if (forecastData is Map<String, dynamic>) {
//     var forecastList = forecastData['forecast'];  // Assuming 'forecast' contains the list you want
//     if (forecastList is List) {
//       return List<Map<String, dynamic>>.from(forecastList);
//     } else {
//       throw Exception("Expected a List for forecast data.");
//     }
//   } else {
//     throw Exception("Unexpected response format. Expected a Map.");
//   }
// }

// static Future<dynamic> fetchAdaptiveReminderStrategy(String userId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/users/$userId/adaptive-reminder-strategy'),
//         headers: {
//           'Content-Type': 'application/json',
//           // Add any necessary authentication headers
//         },
//       );
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to load adaptive reminder strategy');
//       }
//     } catch (e) {
//       print('Error fetching adaptive reminder strategy: $e');
//       rethrow;
//     }
//   }

  /// my 2 codes
//   static Future<Map<String, dynamic>> fetchAdaptiveReminderStrategy(String userId) async {
//   try {
//     final response = await http.get(
//       Uri.parse('$baseUrl/users/$userId/caregiver-insights'),
//       headers: {'Content-Type': 'application/json'},
//     );
//     if (response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       if (decoded is Map<String, dynamic>) {
//         return decoded;
//       } else {
//         throw Exception('Unexpected response format: Expected a JSON object.');
//       }
//     } else {
//       throw Exception('Failed to load adaptive reminder strategy');
//     }
//   } catch (e) {
//     print('Error fetching adaptive reminder strategy: $e');
//     rethrow;
//   }
// }

//   static Future<List<dynamic>> fetchForecastDelays(String userId) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/users/$userId/forecast'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         // Add any necessary authentication headers
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       return json.decode(response.body);
  //     } else {
  //       throw Exception('Failed to load forecast delays');
  //     }
  //   } catch (e) {
  //     print('Error fetching forecast delays: $e');
  //     rethrow;
  //   }
  // }

  // 22222222 mine///
  //  static Future<List<dynamic>> fetchForecastDelays(String userId) async {
  //   final response = await http.get(Uri.parse('$baseUrl/users/$userId/forecast'));
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to load forecast delays');
  //   }
  // }

  // static Future<Map<String, dynamic>> fetchAdaptiveReminderStrategy(String userId) async {
  //   final response = await http.get(Uri.parse('$baseUrl/users/$userId/caregiver-insights'));
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to load reminder strategy');
  //   }
  // }

  static Future<List<dynamic>> fetchForecastDelays(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/users/$userId/forecast'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load forecast delays');
    }
  }

  // static Future<Map<String, dynamic>> fetchAdaptiveReminderStrategy(String userId) async {
  //   final response = await http.get(Uri.parse('$baseUrl/users/$userId/caregiver-insights'));
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to load reminder strategy');
  //   }
  // }

  static Future<Map<String, dynamic>> fetchAdaptiveReminderStrategy(
      String userId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/users/$userId/caregiver-insights'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load reminder strategy');
      }
    } catch (e) {
      throw Exception('Failed to load reminder strategy: $e');
    }
  }

  // Call the Flask API to generate analysis data ////laasst codeeee******
  // static Future<void> generateAnalysis(String userId) async {
  //   try {
  //     final response =
  //         await http.get(Uri.parse('$baseUrl/users/$userId/analyze-tasks'));
  //     if (response.statusCode == 200) {
  //       print('Analysis data generated successfully for user: $userId');
  //     } else {
  //       print('Failed to generate analysis data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error generating analysis data: $e');
  //   }
  // }

  // correctt but the image
  // Future<Map<String, dynamic>?> analyzeTasks(String userId) async {
  //   final response = await http.get(Uri.parse('$baseUrl/users/$userId/analyze-tasks'));
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     return null;
  //   }
  // }

  // Future<Map<String, dynamic>?> analyzeTasks(String userId) async {
  //   try {
  // print('Fetching analysis data from: $baseUrl/users/$userId/analyze-tasks');
  // final stopwatch = Stopwatch()..start();
  //     final response = await http
  //         .get(Uri.parse('$baseUrl/users/$userId/analyze-tasks'))
  //         .timeout(Duration(seconds: 60)); // Increase timeout to 60 seconds
  // stopwatch.stop();
  // print('API call completed in ${stopwatch.elapsedMilliseconds} ms');
  //     if (response.statusCode == 200) {
  //       return json.decode(response.body);
  //     } else {
  //       print('API Error: ${response.statusCode}');
  //       return null;
  //     }
  //   } on TimeoutException catch (e) {
  //     print('TimeoutException: $e');
  //     return null;
  //   } on SocketException catch (e) {
  //     print('SocketException: $e');
  //     return null;
  //   } catch (e) {
  //     print('Unexpected Error: $e');
  //     return null;
  //   }
  // }

  //with retry
  // Future<Map<String, dynamic>?> analyzeTasks(String userId,
  //     {int retries = 3}) async {
  //   for (int i = 0; i < retries; i++) {
  //     try {
  //       print(
  //           'Fetching analysis data from: $baseUrl/users/$userId/analyze-tasks');
  //       final stopwatch = Stopwatch()..start();
  //       final response = await http
  //           .get(Uri.parse('$baseUrl/users/$userId/analyze-tasks'))
  //           .timeout(Duration(seconds: 120)); // Increase timeout to 120 seconds
  //       stopwatch.stop();
  //       print('API call completed in ${stopwatch.elapsedMilliseconds} ms');
  //       if (response.statusCode == 200) {
  //         return json.decode(response.body);
  //       } else {
  //         print('API Error: ${response.statusCode}');
  //       }
  //     } on TimeoutException catch (e) {
  //       print('TimeoutException: $e');
  //     } on SocketException catch (e) {
  //       print('SocketException: $e');
  //     } catch (e) {
  //       print('Unexpected Error: $e');
  //     }
  //     // Wait for a short delay before retrying
  //     await Future.delayed(Duration(seconds: 5));
  //   }
  //   return null; // Return null if all retries fail
  // }

 ////before lasstt*** 2 functions
//   Future<Map<String, dynamic>?> analyzeTasks(String userId) async {
//   try {
//     final response = await http
//         .get(Uri.parse('$baseUrl/users/$userId/analyze-tasks'))
//         .timeout(Duration(seconds: 120)); // Increase timeout to 120 seconds
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       print('API Error: ${response.statusCode}');
//       return null;
//     }
//   } on TimeoutException catch (e) {
//     print('TimeoutException: $e');
//     return null;
//   } on SocketException catch (e) {
//     print('SocketException: $e');
//     return null;
//   } catch (e) {
//     print('Unexpected Error: $e');
//     return null;
//   }
// } 
//   Future<void> analyzeAndSaveTasks(
//       String userId, FirebaseUtils firebaseUtils) async {
//     try {
//       // Fetch analysis data from API
//       final analysisData = await analyzeTasks(userId);
//       if (analysisData != null) {
//         // Save analysis data to Firestore
//         print('API Response: $analysisData');
//         // print('Firestore Data: ${doc.data()}');
//         await firebaseUtils.saveAnalysisData(userId, analysisData);
//       } else {
//         throw Exception('Failed to fetch analysis data from API');
//       }
//     } catch (e) {
//       print('Error in analyzeAndSaveTasks: $e');
//       throw e;
//     }
//   }

//   static Future<File?> downloadScatterPlot(String url) async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final directory = await getTemporaryDirectory();
//         final file = File('${directory.path}/scatter_plot.png');
//         await file.writeAsBytes(response.bodyBytes);
//         return file;
//       } else {
//         print('Failed to download scatter plot: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error downloading scatter plot: $e');
//       return null;
//     }

//     /// Example of another endpoint: Fetch user details
//     // static Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
//     //   return await getRequest('users/$userId/details');
//     // }
//   }



}
