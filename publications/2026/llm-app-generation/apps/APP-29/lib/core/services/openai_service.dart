import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _apiKey = 'your-openai-api-key-here'; // Replace with actual API key
  
  final http.Client _client = http.Client();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_apiKey',
  };

  Future<String> sendMessage(List<Message> messages, {String model = 'gpt-3.5-turbo'}) async {
    try {
      final messagesJson = messages.map((message) => {
        'role': message.role.name,
        'content': message.content,
      }).toList();

      final response = await _client.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: _headers,
        body: jsonEncode({
          'model': model,
          'messages': messagesJson,
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else if (response.statusCode == 401) {
        return 'API key is invalid or missing. Please check your OpenAI API key configuration.';
      } else if (response.statusCode == 429) {
        return 'Rate limit exceeded. Please try again later.';
      } else {
        return 'Sorry, I encountered an error. Please try again.';
      }
    } catch (e) {
      // Simulate a response for demo purposes when API key is not configured
      if (_apiKey == 'your-openai-api-key-here') {
        return _generateMockResponse(messages.last.content);
      }
      return 'Network error. Please check your internet connection and try again.';
    }
  }

  Future<String> analyzeImage(String imagePath, String prompt) async {
    try {
      // For demo purposes, return a mock response
      // In a real implementation, you would encode the image and send it to OpenAI's vision API
      if (_apiKey == 'your-openai-api-key-here') {
        return _generateMockImageAnalysis(prompt);
      }

      final imageBytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final response = await _client.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: _headers,
        body: jsonEncode({
          'model': 'gpt-4-vision-preview',
          'messages': [
            {
              'role': 'user',
              'content': [
                {'type': 'text', 'text': prompt},
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
                }
              ]
            }
          ],
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Sorry, I couldn\'t analyze the image. Please try again.';
      }
    } catch (e) {
      return _generateMockImageAnalysis(prompt);
    }
  }

  Future<String> generateImage(String prompt) async {
    try {
      // For demo purposes, return a mock response
      if (_apiKey == 'your-openai-api-key-here') {
        return _generateMockImageUrl(prompt);
      }

      final response = await _client.post(
        Uri.parse('$_baseUrl/images/generations'),
        headers: _headers,
        body: jsonEncode({
          'model': 'dall-e-3',
          'prompt': prompt,
          'n': 1,
          'size': '1024x1024',
          'quality': 'standard',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'][0]['url'];
      } else {
        throw Exception('Failed to generate image');
      }
    } catch (e) {
      return _generateMockImageUrl(prompt);
    }
  }

  String _generateMockResponse(String userMessage) {
    final responses = [
      "I'm a demo version of ChatGPT. To get real responses, please configure your OpenAI API key in the OpenAIService class.",
      "This is a simulated response. For actual AI conversations, you'll need to add your OpenAI API key.",
      "Hello! I'm running in demo mode. To enable real AI responses, please set up your OpenAI API key.",
      "I understand you're asking about: '$userMessage'. This is a mock response - configure your API key for real interactions.",
    ];
    
    return responses[userMessage.hashCode % responses.length];
  }

  String _generateMockImageAnalysis(String prompt) {
    return "I can see the image you've shared. This is a demo response for image analysis. "
           "To get real image analysis, please configure your OpenAI API key. "
           "Your prompt was: '$prompt'";
  }

  String _generateMockImageUrl(String prompt) {
    // Return a placeholder image URL for demo purposes
    return 'https://via.placeholder.com/1024x1024/10A37F/FFFFFF?text=Generated+Image+Demo';
  }

  void dispose() {
    _client.close();
  }
}