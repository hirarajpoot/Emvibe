class AppConfig {
  // API Configuration
  static const String openAIApiKey = 'YOUR_OPENAI_API_KEY'; // Replace with your actual API key
  static const String openAIBaseUrl = 'https://api.openai.com/v1/chat/completions';
  
  // App Configuration
  static const String appName = 'EmVibe';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your AI Chatbot Companion';

  // Stripe Configuration (client-side)
  // Set your Stripe publishable key here (test or live). Do NOT put secret keys in the app.
  static const String stripePublishableKey = 'pk_test_51S464IBTXzSfQeThpfhyuJbIvm6dNeQJf2jLxkeDFZy4AD5RvrHTzpsGitK0WgJGHYGQSJ3QK9tKT94sNNs9auYw00TBYJJKNp';
  static const String stripeMerchantId = 'merchant.emvibe';
  // Your backend base URL that creates PaymentIntents and Ephemeral Keys
  static const String stripeBackendBaseUrl = 'https://us-central1-emvibe-eba0b.cloudfunctions.net';
  
  // Chat Configuration
  static const int maxConversationHistory = 10;
  static const int maxTokens = 150;
  static const double temperature = 0.7;
  static const Duration typingDelay = Duration(milliseconds: 800);
  static const Duration responseTimeout = Duration(seconds: 30);
  
  // UI Configuration
  static const double defaultBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Feature Flags
  static const bool enableAIService = true;
  static const bool enableVoiceRecording = true;
  static const bool enableSpeechToText = true;
  static const bool enableImageOCR = true;
  static const bool enableNotifications = true;
  static const bool enableDarkMode = true;
  static const bool enableMultiLanguage = true;
  
  // Fallback Configuration
  static const bool useFallbackResponses = true;
  static const int fallbackResponseCount = 10;
  
  // Security Configuration
  static const bool enableApiKeyValidation = true;
  static const bool enableErrorLogging = true;
  
  /// Check if AI service is properly configured
  static bool get isAIConfigured => openAIApiKey != 'YOUR_OPENAI_API_KEY' && openAIApiKey.isNotEmpty;
  
  /// Get AI model to use
  static String get aiModel => 'gpt-3.5-turbo';
  
  /// Get system prompt based on persona
  static String getSystemPrompt(String persona) {
    switch (persona.toLowerCase()) {
      case 'friendly':
        return "You are a friendly and helpful AI assistant. Be warm, encouraging, and supportive in your responses. Keep responses concise and conversational.";
      case 'professional':
        return "You are a professional AI assistant. Be formal, precise, and business-like in your responses. Provide clear and structured information.";
      case 'creative':
        return "You are a creative AI assistant. Be imaginative, artistic, and inspiring in your responses. Use metaphors and creative language.";
      case 'technical':
        return "You are a technical AI assistant. Be precise, detailed, and analytical in your responses. Focus on accuracy and technical depth.";
      case 'casual':
        return "You are a casual AI assistant. Be relaxed, informal, and easy-going in your responses. Use everyday language and be approachable.";
      default:
        return "You are a helpful AI assistant. Be kind, informative, and engaging in your responses.";
    }
  }
  
  /// Get fallback responses
  static List<String> get fallbackResponses => [
    "I'm here to help! How can I assist you today?",
    "That's an interesting question. Let me think about that.",
    "I understand what you're saying. Could you tell me more?",
    "Thanks for sharing that with me. What would you like to know?",
    "I'm learning from our conversation. What else can I help you with?",
    "That's a great point! I'd love to hear more about your thoughts.",
    "I'm here to chat and help however I can. What's on your mind?",
    "Interesting perspective! How did you come to that conclusion?",
    "I appreciate you sharing that. Is there anything specific you'd like to explore?",
    "That sounds fascinating! Tell me more about it.",
  ];
  
  /// Get welcome messages
  static List<String> get welcomeMessages => [
    "Hello! I'm EmVibe, your AI assistant. How can I help you today?",
    "Hi there! I'm here to chat and assist you with anything you need. What's on your mind?",
    "Welcome! I'm your friendly AI companion. Feel free to ask me anything or just have a conversation!",
    "Hey! Great to meet you. I'm EmVibe and I'm excited to chat with you. What would you like to talk about?",
    "Hello! I'm your AI assistant, ready to help and chat. How can I make your day better?",
  ];
}

