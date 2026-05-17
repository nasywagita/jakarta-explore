import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'providers/quiz_provider.dart';
import 'data/models/question_model.dart';
import 'data/models/quiz_model.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';

class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({super.key});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> with SingleTickerProviderStateMixin {
  final List<String> _optionLetters = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final quiz = provider.currentQuiz;
    final question = provider.currentQuestion;

    if (quiz == null || question == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final double progressRatio = 
        (provider.currentQuestionIndex + 1) / quiz.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(quiz.title),
            _buildProgressRow(provider, progressRatio, quiz.questions.length),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    _buildQuestionCard(quiz, question),
                    const SizedBox(height: 32),
                    ...List.generate(
                      question.options.length,
                      (index) => _buildOptionCard(
                        context, 
                        provider, 
                        question, 
                        index, 
                        question.options[index],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            if (provider.hasAnswered)
              _buildResultOverlay(provider, question, quiz.questions.length),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF424752)),
                onPressed: () {
                  context.read<QuizProvider>().reset();
                  context.pop();
                },
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(QuizProvider provider, double progressRatio, int total) {
    bool isBlinking = provider.timeLeft <= 5 && !provider.hasAnswered;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PERTANYAAN ${provider.currentQuestionIndex + 1} DARI $total',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutQuint,
                      alignment: Alignment.centerLeft,
                      widthFactor: progressRatio,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: isBlinking ? Colors.red : const Color(0xFFE2E8F0),
                width: isBlinking ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isBlinking ? Colors.red.withAlpha(50) : Colors.black.withAlpha(10),
                  blurRadius: 10,
                  spreadRadius: isBlinking ? 4 : 0,
                )
              ],
            ),
            child: Text(
              '${provider.timeLeft}',
              style: AppTextStyles.h4.copyWith(
                color: isBlinking ? Colors.red : const Color(0xFF191C21),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuizModel quiz, QuestionModel question) {
    String displayImage = question.imageUrl;
    if (displayImage.contains('placehold.co')) {
      displayImage = quiz.imageUrl;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'question_image_${question.questionText}',
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                image: DecorationImage(
                  image: NetworkImage(displayImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withAlpha(150),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              question.questionText,
              style: AppTextStyles.h4.copyWith(
                color: const Color(0xFF191C21),
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, QuizProvider provider, QuestionModel question, int index, String text) {
    
    final bool isSelected = provider.selectedAnswerIndex == index;
    final bool isCorrectOption = index == question.correctAnswerIndex;
    
    Color borderColor = Colors.transparent;
    Color bgColor = Colors.white;
    Color iconBgColor = const Color(0xFFF1F5F9);
    Color iconTextColor = const Color(0xFF64748B);
    Color mainTextColor = const Color(0xFF334155);

    if (provider.hasAnswered) {
      if (isCorrectOption) {
        borderColor = const Color(0xFF10B981);
        bgColor = const Color(0xFFECFDF5);
        iconBgColor = const Color(0xFF10B981);
        iconTextColor = Colors.white;
        mainTextColor = const Color(0xFF065F46);
      } else if (isSelected) {
        borderColor = const Color(0xFFEF4444);
        bgColor = const Color(0xFFFEF2F2);
        iconBgColor = const Color(0xFFEF4444);
        iconTextColor = Colors.white;
        mainTextColor = const Color(0xFF991B1B);
      } else {
        // Unselected options fade out slightly
        mainTextColor = const Color(0xFF94A3B8);
        iconTextColor = const Color(0xFFCBD5E1);
      }
    } else if (isSelected) {
      borderColor = AppColors.primary;
      bgColor = AppColors.primary.withAlpha(10);
      iconBgColor = AppColors.primary;
      iconTextColor = Colors.white;
      mainTextColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: () {
        provider.submitAnswer(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor == Colors.transparent ? const Color(0xFFE2E8F0) : borderColor, 
            width: isSelected || (provider.hasAnswered && isCorrectOption) ? 2 : 1
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected && !provider.hasAnswered
                  ? AppColors.primary.withAlpha(30)
                  : Colors.black.withAlpha(4),
              blurRadius: isSelected ? 12 : 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _optionLetters[index],
                style: AppTextStyles.h5.copyWith(
                  color: iconTextColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: mainTextColor,
                  fontWeight: isSelected || (provider.hasAnswered && isCorrectOption) ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (provider.hasAnswered && isCorrectOption)
              const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 28),
            if (provider.hasAnswered && isSelected && !isCorrectOption)
              const Icon(Icons.cancel, color: Color(0xFFEF4444), size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildResultOverlay(QuizProvider provider, QuestionModel question, int totalQuestions) {
    final bool isCorrect = provider.isCorrect;
    final bool isTimeout = provider.selectedAnswerIndex == -1;

    final Color bgColor = isTimeout
        ? const Color(0xFFFFF7ED)
        : isCorrect
            ? const Color(0xFFECFDF5)
            : const Color(0xFFFEF2F2);
    final Color textColor = isTimeout
        ? const Color(0xFFC2410C)
        : isCorrect
            ? const Color(0xFF047857)
            : const Color(0xFFB91C1C);
    final Color subtitleColor = isTimeout
        ? const Color(0xFF9A3412)
        : isCorrect
            ? const Color(0xFF059669)
            : const Color(0xFF991B1B);
    final IconData icon = isTimeout
        ? Icons.timer_off
        : isCorrect
            ? Icons.check_circle
            : Icons.cancel;
    final Color iconColor = isTimeout
        ? const Color(0xFFF97316)
        : isCorrect
            ? const Color(0xFF10B981)
            : const Color(0xFFEF4444);

    final String titleText = isTimeout
        ? 'Waktu Habis!'
        : isCorrect
            ? 'Hebat! Jawaban Benar'
            : 'Ups! Kurang Tepat';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 40,
            offset: const Offset(0, -10),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleText,
                        style: AppTextStyles.h4.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        question.explanation,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isCorrect) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.stars, color: Color(0xFFF59E0B), size: 28),
                      const SizedBox(width: 8),
                      Text(
                        '+${provider.currentQuiz!.rewardPoints ~/ totalQuestions} Poin',
                        style: AppTextStyles.h5.copyWith(
                          color: const Color(0xFFF59E0B),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed: () async {
                    if (provider.isLastQuestion) {
                      await provider.finishQuiz();
                      if (!mounted) return;
                      context.pushReplacement('/leaderboard');
                    } else {
                      provider.nextQuestion();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primary.withAlpha(100),
                  ),
                  child: Text(
                    provider.isLastQuestion ? 'Selesai & Lihat Hasil' : 'Lanjut ke Soal Berikutnya',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
