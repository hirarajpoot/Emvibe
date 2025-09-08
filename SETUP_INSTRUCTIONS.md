# EmVibe Chatbot App - Setup Instructions

## 🚀 Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Configure Firebase
- Make sure your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are properly configured
- Firebase project should have Authentication and Firestore enabled

### 3. Configure AI Service (Optional)
To enable real AI responses, you need to:

1. **Get an OpenAI API Key:**
   - Go to [OpenAI Platform](https://platform.openai.com/)
   - Create an account and get your API key
   - Add credits to your account

2. **Update Configuration:**
   - Open `lib/config/app_config.dart`
   - Replace `YOUR_OPENAI_API_KEY` with your actual API key:
   ```dart
   static const String openAIApiKey = 'sk-your-actual-api-key-here';
   ```

3. **Alternative AI Services:**
   - You can modify `AIService` to use other AI providers like:
     - Google Gemini
     - Anthropic Claude
     - Local AI models
     - Custom AI endpoints

### 4. Run the App
```bash
flutter run
```

## 🔧 Features

### ✅ Implemented Features
- **Multi-language Support** (English, Urdu, Hindi, Arabic, French, Spanish, German, Chinese)
- **Dark/Light Theme** with custom backgrounds
- **Voice Recording** and playback
- **Speech-to-Text** recognition
- **Image OCR** (Optical Character Recognition)
- **File Attachments** support
- **Chat History** management
- **Message Saving** (Book feature)
- **Push Notifications**
- **Responsive UI** with ScreenUtil
- **Error Handling** and fallback responses
- **Persona Selection** (Friendly, Professional, Creative, Technical, Casual)

### 🎯 AI Integration
- **Smart Responses** with contextual understanding
- **Persona-based** conversation styles
- **Fallback System** when AI service is unavailable
- **Multi-language** AI responses
- **Conversation History** for context

### 🔒 Security Features
- **API Key Management** in configuration
- **Error Handling** without exposing sensitive data
- **Permission Management** for camera, microphone, storage
- **Input Validation** and sanitization

## 📱 App Structure

```
lib/
├── config/
│   └── app_config.dart          # App configuration and settings
├── AppUi/
│   ├── AppScreens/              # All app screens
│   ├── Controllers/             # Business logic controllers
│   ├── Models/                  # Data models
│   ├── Utils/                   # Utility classes
│   └── translations/            # Multi-language support
└── main.dart                    # App entry point
```

## 🛠️ Customization

### Adding New Languages
1. Add language code to `app_translations.dart`
2. Create translation files in `translations/` folder
3. Update language selection UI

### Adding New Personas
1. Update `AppConfig.getSystemPrompt()` method
2. Add persona options to UI
3. Update persona selection logic

### Customizing AI Responses
1. Modify `AIService.generateContextualResponse()`
2. Update fallback responses in `AppConfig`
3. Customize system prompts for different personas

## 🐛 Troubleshooting

### Common Issues

1. **AI Service Not Working:**
   - Check if API key is properly configured
   - Verify internet connection
   - Check API key credits/usage limits

2. **Voice Features Not Working:**
   - Grant microphone permissions
   - Check device microphone functionality
   - Verify speech-to-text service availability

3. **Image OCR Not Working:**
   - Grant camera/storage permissions
   - Check image quality and format
   - Verify Tesseract OCR installation

4. **Firebase Issues:**
   - Verify Firebase configuration files
   - Check Firebase project settings
   - Ensure proper authentication setup

### Performance Optimization
- Use `flutter build apk --release` for production builds
- Enable R8/ProGuard for Android
- Optimize images and assets
- Use lazy loading for large chat histories

## 📋 TODO / Future Enhancements

- [ ] **Real-time Chat** with WebSocket support
- [ ] **User Authentication** with Firebase Auth
- [ ] **Cloud Sync** for chat history
- [ ] **Advanced AI Features** (image analysis, code generation)
- [ ] **Voice Cloning** for personalized responses
- [ ] **Chat Export** (PDF, text, etc.)
- [ ] **Widget Support** for quick access
- [ ] **Offline Mode** with local AI models
- [ ] **Analytics** and usage tracking
- [ ] **Premium Features** with subscription

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you encounter any issues or need help:
1. Check the troubleshooting section
2. Review the code comments
3. Create an issue on GitHub
4. Contact the development team

---

**Happy Chatting with EmVibe! 🤖💬**

