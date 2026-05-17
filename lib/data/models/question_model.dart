class QuestionModel {
  final String id;
  final String questionText;
  final String description;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String imageUrl;

  QuestionModel({
    required this.id,
    required this.questionText,
    this.description = '',
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.imageUrl = 'https://placehold.co/340x192.png',
  });
}
