import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'providers/quiz_provider.dart';
import 'providers/auth_provider.dart';
import 'main_wrapper.dart';
import 'data/models/quiz_model.dart';
import 'data/local/mock_quizzes.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kuis Spesial Minggu Ini',
                        style: AppTextStyles.h4.copyWith(
                          color: const Color(0xFF191C21),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPromoQuiz(context),
                      const SizedBox(height: 32),
                      Text(
                        'Semua Kuis',
                        style: AppTextStyles.h5.copyWith(
                          color: const Color(0xFF191C21),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildQuizList(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final name = auth.user?.name ?? 'Penjelajah';
        final avatarUrl = auth.user?.profileImage ??
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=0D8ABC&color=fff';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo2.png',
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.explore_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'JakartaExplore',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => MainWrapper.tabNotifier.value = 4,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD7E2FF), width: 2),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        color: AppColors.primary.withAlpha(20),
                        child: Center(
                          child: Text(
                            name[0].toUpperCase(),
                            style: AppTextStyles.h6
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromoQuiz(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 192,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              image: DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1555899434-94d1368aa7af?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      'POIN 2X',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF973C00),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      MockQuizzes.getQuizzes().first.category.toUpperCase(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.stars, color: Color(0xFFFFD700), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${MockQuizzes.getQuizzes().first.rewardPoints} Poin',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF191C21),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  MockQuizzes.getQuizzes().first.title,
                  style: AppTextStyles.h4.copyWith(
                    color: const Color(0xFF191C21),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  MockQuizzes.getQuizzes().first.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF424752),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final quizzes = MockQuizzes.getQuizzes();
                      if (quizzes.isNotEmpty) {
                        context.read<QuizProvider>().startQuiz(quizzes.first);
                        context.push('/quiz-play');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Mulai Kuis Sekarang',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizList(BuildContext context) {
    final quizzes = MockQuizzes.getQuizzes();
    // Skip the first quiz since it's the promo quiz
    final otherQuizzes = quizzes.length > 1 ? quizzes.sublist(1) : [];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          // Desktop: Use Wrap
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: otherQuizzes.map((quiz) {
              return SizedBox(
                width: (constraints.maxWidth - 16) / 2, // 2 columns
                child: _buildQuizListItemWrapper(context, quiz),
              );
            }).toList(),
          );
        }
        
        // Mobile: Use Column
        return Column(
          children: otherQuizzes.map((quiz) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildQuizListItemWrapper(context, quiz),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildQuizListItemWrapper(BuildContext context, quiz) {
    IconData iconData = Icons.quiz;
    Color iconBg = const Color(0xFFD7E2FF);
    Color iconColor = AppColors.primary;

    switch (quiz.category.toLowerCase()) {
      case 'sejarah':
      case 'budaya':
        iconData = Icons.account_balance;
        iconBg = const Color(0xFFFFDBCC);
        iconColor = const Color(0xFF973C00);
        break;
      case 'alam':
        iconData = Icons.park;
        iconBg = const Color(0xFFD1FAE5);
        iconColor = const Color(0xFF059669);
        break;
      case 'religi':
        iconData = Icons.mosque; // fallback
        iconBg = const Color(0xFFFEE2E2);
        iconColor = const Color(0xFFDC2626);
        break;
    }

    return _buildQuizListItem(
      context,
      quiz: quiz,
      icon: iconData,
      iconBg: iconBg,
      iconColor: iconColor,
    );
  }

  Widget _buildQuizListItem(BuildContext context, {
    required QuizModel quiz,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<QuizProvider>().startQuiz(quiz);
        context.push('/quiz-play');
      },
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: const Color(0xFF191C21),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quiz.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${quiz.rewardPoints} Poin',
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFFF59E0B),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Icon(Icons.chevron_right, color: const Color(0xFF94A3B8), size: 20),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
