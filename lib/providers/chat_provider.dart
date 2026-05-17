import 'package:flutter/material.dart';
import '../data/models/chat_message.dart';
import '../data/services/ai_service.dart';

class ChatProvider extends ChangeNotifier {
  final AiService _aiService = AiService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  ChatProvider() {
    _aiService.initializeChat();
    // Add initial greeting message
    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Halo! Saya JakartaGuide AI, asisten perjalanan pintar Anda. Ingin tahu rute tercepat ke Monas atau butuh rekomendasi kuliner hidden gem di Jakarta?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isLoading = true;
    notifyListeners();

    try {
      final responseText = await _aiService.sendMessage(text);
      final aiMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(aiMsg);
    } catch (e) {
      final errorMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Terjadi kesalahan: $e',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMsg);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _aiService.initializeChat();
    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Halo! Saya JakartaGuide AI, asisten perjalanan pintar Anda. Ingin tahu rute tercepat ke Monas atau butuh rekomendasi kuliner hidden gem di Jakarta?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
