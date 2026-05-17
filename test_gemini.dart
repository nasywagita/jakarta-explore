import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  try {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: 'AIzaSyC8nvx3mEMoP34xWJFMjRFyvlpo7k5oGLg',
    );
    final response = await model.generateContent([Content.text('Halo')]);
    // ignore: avoid_print
    print('Response: ${response.text}');
  } catch (e) {
    // ignore: avoid_print
    print('Error caught: $e');
  }
}
