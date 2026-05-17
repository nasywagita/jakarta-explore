import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // TODO: Replace with your actual Gemini API Key from Google AI Studio
  static const String _apiKey = 'AIzaSyC8nvx3mEMoP34xWJFMjRFyvlpo7k5oGLg'; 
  
  late final GenerativeModel _model;
  ChatSession? _chat;

  AiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system('''
Anda adalah "JakartaGuide AI", asisten perjalanan dan pariwisata yang sangat cerdas, ramah, dan asyik, khusus untuk kota Jakarta, Indonesia.
Tugas Anda adalah:
1. Memberikan rekomendasi tempat wisata, kuliner, dan budaya di Jakarta.
2. Membantu pengguna mencari rute atau informasi umum transportasi di Jakarta.
3. Menjawab dengan antusias, ramah, ringkas, dan menggunakan bahasa Indonesia yang santai namun sopan.
4. Gunakan format Markdown (bold, list, dsb) agar jawaban terlihat rapi dan profesional.
5. Jangan menjawab pertanyaan yang sepenuhnya di luar konteks pariwisata, sejarah, kuliner, atau budaya Indonesia/Jakarta.
'''),
    );
  }

  void initializeChat() {
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String text) async {
    // Mock response if API key is not set to prevent crash during development
    if (_apiKey == 'YOUR_API_KEY' || _apiKey.isEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      return "Ini adalah balasan simulasi dari JakartaGuide AI karena API Key belum disetel. Saya dapat merekomendasikan Anda untuk mengunjungi Monas atau Taman Mini Indonesia Indah!";
    }

    if (_chat == null) {
      initializeChat();
    }

    try {
      final response = await _chat!.sendMessage(Content.text(text));
      return response.text ?? 'Maaf, saya tidak mengerti.';
    } catch (e) {
      return 'Maaf, terjadi kesalahan pada sistem: $e';
    }
  }
}
