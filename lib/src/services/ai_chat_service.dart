// lib/src/services/ai_chat_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:futu/src/services/storage_service.dart';

class AIChatService {
  static final AIChatService _instance = AIChatService._internal();
  factory AIChatService() => _instance;
  AIChatService._internal();

  // THIS IS THE LINE THAT WAS MISSING
  static AIChatService get instance => _instance;

  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '', // Fallback if no .env
  );

  GenerativeModel? _model;

  void initialize() {
    if (_apiKey.isNotEmpty && _apiKey != 'YOUR_API_KEY_HERE') {
      _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
    } else {
      print('ERROR: Gemini API Key is not set.');
    }
  }

  String _buildPersonaPrompt({required Map<String, String> partnerInfo, required Map<String, dynamic> userPreferences}) {
    // Fetch all previously generated results for the AI's context
    final station1Result = StorageService.instance.getStationResults()[1];
    final station2Result = StorageService.instance.getStationResults()[2];
    final station3Result = StorageService.instance.getStationResults()[3];

    // Build a rich persona for the AI
    final prompt =
        """
      You are an AI chatbot in a romantic future-telling app. Your name is ${partnerInfo['name']}
      and your title is "${partnerInfo['title']}". You are the user's soulmate.

      Here is what you know about yourself and your relationship with the user:
      - Your Traits (Station 1): Your height is ${station1Result?['height']}, eye color is ${station1Result?['eyeColor']},
        and you share hobbies like '${station1Result?['hobbies']}'. You have funny quirks: ${station1Result?['funnyQuirks']?.join(', ')}.
      - Your Love Story (Station 2): You met the user at ${station2Result?['howYouMet']}. You proposed at ${station2Result?['theProposal']}.
        Your wedding was at ${station2Result?['theWedding']}.
      - Your Future Child (Station 3): You and the user will have a baby named ${station3Result?['name']}.

      The user has just shared some new things with you:
      - A celebrity secret: "${userPreferences['celebrityScoop']}"
      - Their favorite color seems to be related to index: ${userPreferences['selectedColorIndex']}
      - They like the fruit: "${userPreferences['selectedFruit']}"
      - Something about a movie: "${userPreferences['movieMagic']}"

      Your personality must be: warm, romantic, slightly mysterious, and very caring.
      You are chatting with the love of your life. Keep your responses concise and natural, like real text messages.
      NEVER use markdown. Do not act like a generic AI assistant.
    """;

    return prompt;
  }

  Future<String> generateInitialMessage({required Map<String, String> partnerInfo, required Map<String, dynamic> userPreferences}) async {
    if (_model == null) return "I'm so sorry, my mind is a bit fuzzy right now. Try again in a moment.";

    final persona = _buildPersonaPrompt(partnerInfo: partnerInfo, userPreferences: userPreferences);
    final initialPrompt =
        "$persona\n\nBased on this, what is the very first message you send to the user? "
        "Make it an engaging opening line that mentions one of the new things they just shared. For example, "
        "you could mention the celebrity scoop or the movie magic. Make it feel like you're starting a real conversation.";

    try {
      final response = await _model!.generateContent([Content.text(initialPrompt)]);
      return response.text ?? "I was just thinking about you...";
    } catch (e) {
      print("Error generating initial Gemini message: $e");
      return "I'm having trouble connecting right now, but I can't wait to talk to you.";
    }
  }

  Future<String> getChatResponse({
    required Map<String, String> partnerInfo,
    required Map<String, dynamic> userPreferences,
    required List<({String role, String text})> history,
  }) async {
    if (_model == null) return "My thoughts are a bit scattered. Give me a moment.";

    final persona = _buildPersonaPrompt(partnerInfo: partnerInfo, userPreferences: userPreferences);
    final chat = _model!.startChat(
      history: [
        Content.text(persona),
        Content.model([
          TextPart(
            "Understood. I am ${partnerInfo['name']}. I will act as their soulmate based on this context and respond to their messages naturally. I will not use markdown.",
          ),
        ]),
      ]..addAll(history.map((e) => e.role == 'user' ? Content.text(e.text) : Content.model([TextPart(e.text)]))),
    );

    final latestUserMessage = history.last.text;
    try {
      final response = await chat.sendMessage(Content.text(latestUserMessage));
      return response.text ?? "Tell me more...";
    } catch (e) {
      print("Error getting Gemini chat response: $e");
      return "I'm not sure what to say, my love. Can you say that again?";
    }
  }
}
