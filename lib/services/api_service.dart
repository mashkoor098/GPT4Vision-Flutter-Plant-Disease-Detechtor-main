// new code
// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import '../constants/api_constants.dart';
//
// class ApiService {
//   final Dio _dio = Dio();
//
//   ApiService() {
//     // Enable logging
//     _dio.interceptors.add(LogInterceptor(responseBody: true));
//   }
//
//
//   Future<String> sendMessageGPT({required String diseaseName}) async {
//     try {
//       final response = await _dio.post(
//         "$BASE_URL/chat/completions",
//         options: Options(
//           headers: {
//             HttpHeaders.authorizationHeader: 'Bearer $API_KEY',
//             HttpHeaders.contentTypeHeader: "application/json",
//           },
//         ),
//         data: {
//           "model": 'gpt-3.5-turbo',
//           "messages": [
//             {
//               "role": "user",
//               "content":
//               "GPT, upon receiving the name of a plant disease, provide three precautionary measures to prevent or manage the disease. These measures should be concise, clear, and limited to one sentence each. No additional information or context is needed—only the three precautions in bullet-point format. The disease is $diseaseName",
//             }
//           ],
//         },
//       );
//
//       final jsonResponse = response.data;
//
//       if (jsonResponse['error'] != null) {
//         throw HttpException(jsonResponse['error']["message"]);
//       }
//
//       return jsonResponse["choices"][0]["message"]["content"];
//     } catch (DioError e) {
//     if (e.response != null) {
//     // Log the response data and status code for further analysis
//     print('Error status: ${e.response?.statusCode}');
//     print('Error data: ${e.response?.data}');
//     } else {
//     print('Error sending request: ${e.message}');
//     }
//     throw Exception('Error: $e');
//     }
//   }
//
//
//   // Function to send image to GPT-4 Vision model
//   Future<String> sendImageToGPT4Vision({
//     required File image,
//     int maxTokens = 50,
//     String model = "gpt-4-vision-preview",
//   }) async {
//     final String base64Image = await encodeImage(image);
//
//     try {
//       final response = await _dio.post(
//         "$BASE_URL/chat/completions",
//         options: Options(
//           headers: {
//             HttpHeaders.authorizationHeader: 'Bearer $API_KEY',
//             HttpHeaders.contentTypeHeader: "application/json",
//           },
//         ),
//         data: jsonEncode({
//           'model': model,
//           'messages': [
//             {
//               'role': 'system',
//               'content': 'You have to give concise and short answers.'
//             },
//             {
//               'role': 'user',
//               'content':
//               'GPT, your task is to identify plant health issues with precision. Analyze any image of a plant or leaf I provide, and detect all abnormal conditions, whether they are diseases, pests, deficiencies, or decay. Respond strictly with the name of the condition identified, and nothing else—no explanations, no additional text. If a condition is unrecognizable, reply with "I don\'t know". If the image is not plant-related, say "Please pick another image".',
//             },
//             {
//               'role': 'user',
//               'content': 'Here is the image: data:image/jpeg;base64,$base64Image',
//             }
//           ],
//           'max_tokens': maxTokens,
//         }),
//       );
//
//       final jsonResponse = response.data;
//
//       if (jsonResponse['error'] != null) {
//         throw HttpException(jsonResponse['error']["message"]);
//       }
//
//       return jsonResponse["choices"][0]["message"]["content"];
//     } catch (e) {
//       print('Error occurred: $e');
//       throw Exception('Error: $e');
//     }
//   }
//
//   // Helper function to encode image as base64
//   Future<String> encodeImage(File image) async {
//     final bytes = await image.readAsBytes();
//     return base64Encode(bytes);
//   }
// }

// new code end


import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class ApiService {
  final Dio _dio = Dio();

  // Function to encode image as base64
  Future<String> encodeImage(File image) async {
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }

  Future<String> sendMessageGPT({required String diseaseName}) async {
    try {
      final response = await _dio.post(
        "$BASE_URL/chat/completions",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $API_KEY',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        data: {
          "model": 'gpt-3.5-turbo',
          "messages": [
            {
              "role": "user",
              "content":
              "GPT, upon receiving the name of a plant disease, provide three precautionary measures to prevent or manage the disease. These measures should be concise, clear, and limited to one sentence each. No additional information or context is needed—only the three precautions in bullet-point format. The disease is $diseaseName",
            }
          ],
        },
      );

      final jsonResponse = response.data;

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      return jsonResponse["choices"][0]["message"]["content"];
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  // Function to send image to GPT-4 Vision model
  Future<String> sendImageToGPT4Vision({
    required File image,
    int maxTokens = 50,
    String model = "gpt-4-vision-preview",
  }) async {
    final String base64Image = await encodeImage(image);

    try {
      final response = await _dio.post(
        "$BASE_URL/chat/completions",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $API_KEY',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        data: jsonEncode({
          'model': model,
          'messages': [
            {
              'role': 'system',
              'content': 'You have to give concise and short answers.'
            },
            {
              'role': 'user',
              'content':
              'GPT, your task is to identify plant health issues with precision. Analyze any image of a plant or leaf I provide, and detect all abnormal conditions, whether they are diseases, pests, deficiencies, or decay. Respond strictly with the name of the condition identified, and nothing else—no explanations, no additional text. If a condition is unrecognizable, reply with "I don\'t know". If the image is not plant-related, say "Please pick another image".',
            },
            // Include base64 encoded image in the message content
            {
              'role': 'user',
              'content': 'Here is the image: data:image/jpeg;base64,$base64Image',
            },
          ],
          'max_tokens': maxTokens,
        }),
      );

      final jsonResponse = response.data;

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      return jsonResponse["choices"][0]["message"]["content"];
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
//
//
//







//
//
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:dio/dio.dart';
//
// import '../constants/api_constants.dart';
//
// class ApiService {
//   final Dio _dio = Dio();
//
//   Future<String> encodeImage(File image) async {
//     final bytes = await image.readAsBytes();
//     return base64Encode(bytes);
//   }
//
//   Future<String> sendMessageGPT({required String diseaseName}) async {
//     try {
//       final response = await _dio.post(
//         "$BASE_URL/chat/completions",
//         options: Options(
//           headers: {
//             HttpHeaders.authorizationHeader: 'Bearer $API_KEY',
//             HttpHeaders.contentTypeHeader: "application/json",
//           },
//         ),
//         data: {
//           "model": 'gpt-3.5-turbo',
//           "messages": [
//             {
//               "role": "user",
//               "content":
//                   "GPT, upon receiving the name of a plant disease, provide three precautionary measures to prevent or manage the disease. These measures should be concise, clear, and limited to one sentence each. No additional information or context is needed—only the three precautions in bullet-point format. The disease is $diseaseName",
//             }
//           ],
//         },
//       );
//
//       final jsonResponse = response.data;
//
//       if (jsonResponse['error'] != null) {
//         throw HttpException(jsonResponse['error']["message"]);
//       }
//
//       return jsonResponse["choices"][0]["message"]["content"];
//     } catch (error) {
//       throw Exception('Error: $error');
//     }
//   }
//
//   Future<String> sendImageToGPT4Vision({
//     required File image,
//     int maxTokens = 50,
//     String model = "gpt-4-vision-preview",
//   }) async {
//     final String base64Image = await encodeImage(image);
//
//     try {
//       final response = await _dio.post(
//         "$BASE_URL/chat/completions",
//         options: Options(
//           headers: {
//             HttpHeaders.authorizationHeader: 'Bearer $API_KEY',
//             HttpHeaders.contentTypeHeader: "application/json",
//           },
//         ),
//         data: jsonEncode({
//           'model': model,
//           'messages': [
//             {
//               'role': 'system',
//               'content': 'You have to give concise and short answers'
//             },
//             {
//               'role': 'user',
//               'content': [
//                 {
//                   'type': 'text',
//                   'text':
//                       'GPT, your task is to identify plant health issues with precision. Analyze any image of a plant or leaf I provide, and detect all abnormal conditions, whether they are diseases, pests, deficiencies, or decay. Respond strictly with the name of the condition identified, and nothing else—no explanations, no additional text. If a condition is unrecognizable, reply with \'I don\'t know\'. If the image is not plant-related, say \'Please pick another image\'',
//                 },
//                 {
//                   'type': 'image_url',
//                   'image_url': {
//                     'url': 'data:image/jpeg;base64,$base64Image',
//                   },
//                 },
//               ],
//             },
//           ],
//           'max_tokens': maxTokens,
//         }),
//       );
//
//       final jsonResponse = response.data;
//
//       if (jsonResponse['error'] != null) {
//         throw HttpException(jsonResponse['error']["message"]);
//       }
//       return jsonResponse["choices"][0]["message"]["content"];
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
// }
