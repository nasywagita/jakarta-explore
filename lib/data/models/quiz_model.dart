import 'question_model.dart';

class QuizModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final int rewardPoints;
  final List<QuestionModel> questions;

  QuizModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.rewardPoints,
    required this.questions,
  });
}
