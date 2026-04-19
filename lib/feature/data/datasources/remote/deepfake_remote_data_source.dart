import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:testvid/feature/data/models/deepfake_result_model.dart';
import 'package:testvid/core/services/app_logger.dart';
import 'package:testvid/core/utils/snackbar_helper.dart';

abstract class DeepfakeRemoteDataSource {
  Future<DeepfakeResultModel> analyzeVideo(File videoFile);
}

// class DeepfakeRemoteDataSourceImpl implements DeepfakeRemoteDataSource {
//   //final String baseUrl = 'http://10.0.2.2:5000';
//   final String baseUrl = 'https://0728-85-153-239-43.ngrok-free.app';

//   @override
//   Future<DeepfakeResultModel> analyzeVideo(File videoFile) async {
//     try {
//       // Create multipart request
//       final uri = Uri.parse('$baseUrl/predict');
//       AppLogger().info('Sending request to: $uri');

//       var request = http.MultipartRequest('POST', uri);

//       // Add file to request
//       var stream = http.ByteStream(videoFile.openRead());
//       var length = await videoFile.length();

//       AppLogger().info('Uploading file: ${videoFile.path} ($length bytes)');

//       var multipartFile = http.MultipartFile(
//         'video',
//         stream,
//         length,
//         filename: videoFile.path.split('/').last,
//       );
//       request.files.add(multipartFile);

//       // Send request and monitor progress
//       AppLogger().info('Sending request to server...');
//       var streamedResponse = await request.send();
//       AppLogger().info('Response status code: ${streamedResponse.statusCode}');

//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         AppLogger().info('Response received successfully');
//         AppLogger().info('Response body: ${response.body}');

//         final Map<String, dynamic> data = json.decode(response.body);

//         return DeepfakeResultModel.fromJson(data);
//       } else {
//         AppLogger().error('Server error: ${response.statusCode}');
//         AppLogger().error('Error body: ${response.body}');
//         throw Exception('Failed to analyze video: ${response.statusCode}');
//       }
//     } catch (e) {
//       AppLogger().error('Error during API call: $e');
//       SnackbarHelper.showError('Error', 'Failed to connect to server: $e');
//       rethrow;
//     }
//   }
// }

class DeepfakeRemoteDataSourceImpl implements DeepfakeRemoteDataSource {
  //final String baseUrl = 'http://10.0.2.2:5000';
  final String baseUrl = 'https://f80f-213-153-145-22.ngrok-free.app';

  @override
  Future<DeepfakeResultModel> analyzeVideo(File videoFile) async {
    try {
      AppLogger().info('Mock API: Starting analysis...');

      // Simulate network delay constraint (2-4 seconds)
      final random = math.Random();
      final delay = 2 + random.nextInt(3);
      await Future.delayed(Duration(seconds: delay));

      // Generate a random result
      final isFake = random.nextBool();
      final confidence = 50.0 +
          random.nextDouble() * 49.9; // Random confidence between 50.0 and 99.9

      final mockResult = DeepfakeResultModel(
        confidence: confidence,
        result: isFake ? 'FAKE' : 'REAL',
        analyzedAt: DateTime.now(),
      );

      AppLogger().info(
          'Mock API: Returning random result: \${mockResult.result} - \${mockResult.confidence}%');

      return mockResult;
    } catch (e) {
      AppLogger().error('Error during mock API call: $e');
      SnackbarHelper.showError('Error', 'Failed to analyze video: $e');
      rethrow;
    }
  }
}
