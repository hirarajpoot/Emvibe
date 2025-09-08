import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../config/app_config.dart';

class AIService {
  static int _fallbackIndex = 0;

  /// Generate AI response using OpenAI API or fallback responses
  static Future<String> generateResponse({
    required String userMessage,
    required String persona,
    required List<Map<String, String>> conversationHistory,
    required String userLanguage,
  }) async {
    try {
      // Check if AI service is configured and enabled
      if (!AppConfig.isAIConfigured || !AppConfig.enableAIService) {
        return _getFallbackResponse();
      }
      
      final response = await http.post(
        Uri.parse(AppConfig.openAIBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.openAIApiKey}',
        },
        body: jsonEncode({
          'model': AppConfig.aiModel,
          'messages': [
            {
              'role': 'system',
              'content': AppConfig.getSystemPrompt(persona),
            },
            ...conversationHistory.map((msg) => {
              'role': msg['role'],
              'content': msg['content'],
            }),
            {
              'role': 'user',
              'content': userMessage,
            },
          ],
          'max_tokens': AppConfig.maxTokens,
          'temperature': AppConfig.temperature,
        }),
      ).timeout(AppConfig.responseTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        log('AI API Error: ${response.statusCode} - ${response.body}');
        return _getFallbackResponse();
      }
      
    } catch (e) {
      log('AI Service Error: $e');
      return _getFallbackResponse();
    }
  }

  /// Get fallback response when AI service is unavailable
  static String _getFallbackResponse() {
    final responses = AppConfig.fallbackResponses;
    final response = responses[_fallbackIndex];
    _fallbackIndex = (_fallbackIndex + 1) % responses.length;
    return response;
  }

  /// Generate contextual response based on user input
  static String generateContextualResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // Greeting responses
    if (message.contains('hello') || message.contains('hi') || message.contains('hey')) {
      return "Hello! It's great to meet you. How can I help you today?";
    }
    
    // Question responses
    if (message.contains('?') || message.startsWith('what') || message.startsWith('how') || 
        message.startsWith('why') || message.startsWith('when') || message.startsWith('where')) {
      return "That's a great question! I'd be happy to help you explore that topic. Could you provide a bit more context?";
    }
    
    // Thank you responses
    if (message.contains('thank') || message.contains('thanks')) {
      return "You're very welcome! I'm glad I could help. Is there anything else you'd like to know?";
    }
    
    // Goodbye responses
    if (message.contains('bye') || message.contains('goodbye') || message.contains('see you')) {
      return "Goodbye! It was nice chatting with you. Feel free to come back anytime!";
    }
    
    // Emotional responses
    if (message.contains('sad') || message.contains('upset') || message.contains('worried')) {
      return "I'm sorry to hear you're feeling that way. I'm here to listen and help however I can. Would you like to talk about it?";
    }
    
    if (message.contains('happy') || message.contains('excited') || message.contains('great')) {
      return "That's wonderful to hear! I'm so glad you're feeling positive. What's making you feel this way?";
    }
    
    // Default contextual response
    return "I understand what you're saying. That's really interesting! Could you tell me more about that?";
  }
}
