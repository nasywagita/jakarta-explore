import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'providers/destinations_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/bookmark_provider.dart';
import 'data/local/mock_quizzes.dart';
import 'main_wrapper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildStatsCard(context),
              _buildFeaturedDestination(context),
              _buildKuisPromo(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header / Greeting ───────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final name = auth.user?.name ?? 'Penjelajah';
        final avatarUrl = auth.user?.profileImage ??
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=0D8ABC&color=fff';

        return Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, const Color(0xFF0077CC)],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, $name! 👋',
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mau jelajah Jakarta hari ini?',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => MainWrapper.tabNotifier.value = 4,
                child: ClipOval(
                  child: Image.network(
                    avatarUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      width: 48,
                      height: 48,
                      color: Colors.white.withAlpha(30),
                      child: Center(
                        child: Text(
                          name[0].toUpperCase(),
                          style: AppTextStyles.h4.copyWith(color: Colors.white),
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

  // ── Stats Card ──────────────────────────────────────────────────────
  Widget _buildStatsCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Consumer2<AuthProvider, BookmarkProvider>(
        builder: (context, auth, bookmark, child) {
          final score = auth.user?.totalPoints ?? 0;
          final totalQuiz = auth.user?.totalQuizCompleted ?? 0;
          final bookmarkCount = bookmark.bookmarkedIds.length;

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                _statItem(
                  icon: Icons.stars_rounded,
                  color: const Color(0xFFF59E0B),
                  value: '$score',
                  label: 'Poin',
                ),
                _statDivider(),
                _statItem(
                  icon: Icons.quiz_rounded,
                  color: AppColors.primary,
                  value: '$totalQuiz',
                  label: 'Kuis Selesai',
                ),
                _statDivider(),
                _statItem(
                  icon: Icons.bookmark_rounded,
                  color: const Color(0xFF10B981),
                  value: '$bookmarkCount',
                  label: 'Tersimpan',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              color: const Color(0xFF1E293B),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _statDivider() => Container(
        width: 1,
        height: 48,
        color: const Color(0xFFE2E8F0),
        margin: const EdgeInsets.symmetric(horizontal: 4),
      );


  // ── Featured Destination ────────────────────────────────────────────
  Widget _buildFeaturedDestination(BuildContext context) {
    return Consumer<DestinationsProvider>(
      builder: (context, provider, child) {
        final all = provider.destinations;
        if (all.isEmpty) return const SizedBox.shrink();

        // Pilih destinasi rating tertinggi sebagai featured
        final sorted = [...all]
          ..sort((a, b) => b.rating.compareTo(a.rating));
        final dest = sorted.first;

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '⭐ Destinasi Terbaik',
                    style:
                        AppTextStyles.h5.copyWith(fontWeight: FontWeight.w800),
                  ),
                  GestureDetector(
                    onTap: () => MainWrapper.tabNotifier.value = 1,
                    child: Text(
                      'Lihat Semua →',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.push('/detail', extra: dest),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          dest.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) =>
                              Container(color: const Color(0xFFE2E8F0)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withAlpha(200),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 20,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dest.name,
                                      style: AppTextStyles.h4.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            color: Colors.white70, size: 13),
                                        const SizedBox(width: 4),
                                        Text(
                                          dest.location,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                  color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCD400),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Color(0xFF6E5C00), size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${dest.rating}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: const Color(0xFF6E5C00),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  // ── Kuis Pilihan ────────────────────────────────────────────────────
  Widget _buildKuisPromo(BuildContext context) {
    final featured = MockQuizzes.getQuizzes().take(2).toList();
    final colors = [
      [const Color(0xFFD7E2FF), const Color(0xFF0056B3)],
      [const Color(0xFFFFDBCC), const Color(0xFF973C00)],
    ];
    final icons = [Icons.history_edu_rounded, Icons.quiz_rounded];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🎯 Kuis Pilihan',
                  style: AppTextStyles.h5
                      .copyWith(fontWeight: FontWeight.w800),
                ),
                GestureDetector(
                  onTap: () => MainWrapper.tabNotifier.value = 2,
                  child: Text(
                    'Lihat Semua →',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 195,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(right: 24),
              itemCount: featured.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final quiz = featured[index];
                return GestureDetector(
                  onTap: () {
                    context.read<QuizProvider>().startQuiz(quiz);
                    context.push('/quiz-play');
                  },
                  child: Container(
                    width: 240,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x08000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: colors[index][0],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(icons[index],
                              color: colors[index][1], size: 24),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          quiz.title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF191C21),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          quiz.description,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF64748B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Mulai (+${quiz.rewardPoints} Poin)',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
