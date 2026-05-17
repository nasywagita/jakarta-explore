import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/question_model.dart';
import '../data/models/quiz_model.dart';
import '../data/services/database_service.dart';

class QuizProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  String? _userId;

  void updateUserId(String? userId) {
    _userId = userId;
  }

  QuizModel? _currentQuiz;
  int _currentQuestionIndex = 0;
  int _score = 0;
  
  // Timer state
  int _timeLeft = 15; // default 15 seconds per question
  Timer? _timer;

  // Answer state
  bool _hasAnswered = false;
  int? _selectedAnswerIndex;
  bool _isCorrect = false;

  QuizModel? get currentQuiz => _currentQuiz;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int get totalScore => 1250; // Dummy data for profile
  int get timeLeft => _timeLeft;
  bool get hasAnswered => _hasAnswered;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get isCorrect => _isCorrect;

  QuestionModel? get currentQuestion {
    if (_currentQuiz == null || _currentQuiz!.questions.isEmpty) return null;
    if (_currentQuestionIndex >= _currentQuiz!.questions.length) return null;
    return _currentQuiz!.questions[_currentQuestionIndex];
  }

  bool get isFinished {
    if (_currentQuiz == null) return true;
    return _currentQuestionIndex >= _currentQuiz!.questions.length;
  }

  bool get isLastQuestion {
    if (_currentQuiz == null) return false;
    return _currentQuestionIndex == _currentQuiz!.questions.length - 1;
  }

  void startQuiz(QuizModel quiz) {
    _currentQuiz = quiz;
    _currentQuestionIndex = 0;
    _score = 0;
    _hasAnswered = false;
    _selectedAnswerIndex = null;
    _isCorrect = false;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timeLeft = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        // Time's up
        _timer?.cancel();
        _timeOut();
      }
    });
  }

  void _timeOut() {
    if (_hasAnswered) return; // double check
    _hasAnswered = true;
    _selectedAnswerIndex = -1; // -1 can mean timeout
    _isCorrect = false;
    notifyListeners();
  }

  void submitAnswer(int index) {
    if (_hasAnswered || currentQuestion == null) return;
    
    _timer?.cancel();
    _hasAnswered = true;
    _selectedAnswerIndex = index;
    _isCorrect = (index == currentQuestion!.correctAnswerIndex);
    
    if (_isCorrect) {
      _score += _currentQuiz!.rewardPoints ~/ _currentQuiz!.questions.length;
    }

    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuiz == null) return;
    
    _currentQuestionIndex++;
    _hasAnswered = false;
    _selectedAnswerIndex = null;
    _isCorrect = false;
    
    if (!isFinished) {
      _startTimer();
    }
    
    notifyListeners();
  }

  Future<void> finishQuiz() async {
    // Save to DB if finished
    if (_userId != null && _currentQuiz != null) {
      await _dbService.addQuizScore(_userId!, _currentQuiz!.id, _score);
    }
  }

  void reset() {
    _timer?.cancel();
    _currentQuiz = null;
    _currentQuestionIndex = 0;
    _score = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
