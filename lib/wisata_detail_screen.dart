import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'data/models/destination_model.dart';
import 'data/local/mock_quizzes.dart';
import 'providers/bookmark_provider.dart';
import 'providers/quiz_provider.dart';

class WisataDetailScreen extends StatelessWidget {
  final DestinationModel destination;

  const WisataDetailScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            // Tampilan Desktop (Split View)
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kiri: Gambar dan Peta
                Expanded(
                  flex: 4,
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(destination.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(color: Colors.black.withOpacity(0.3)),
                        Positioned(
                          top: 24,
                          left: 24,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                            onPressed: () => context.pop(),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Kanan: Konten
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderInfo(context),
                        const SizedBox(height: 24),
                        if (destination.facts.isNotEmpty) _buildFaktaMenarik(),
                        const SizedBox(height: 24),
                        _buildLokasi(context),
                        const SizedBox(height: 32),
                        _buildBottomBar(context),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          // Tampilan Mobile (CustomScrollView bawaan)
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderInfo(context),
                    const SizedBox(height: 24),
                    if (destination.facts.isNotEmpty) _buildFaktaMenarik(),
                    const SizedBox(height: 24),
                    _buildLokasi(context),
                    const SizedBox(height: 32),
                    // Bottom bar embedded in scroll — stable on all platforms
                    _buildBottomBar(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320.0,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      actions: [
        Consumer<BookmarkProvider>(
          builder: (context, provider, child) {
            final isBookmarked = provider.isBookmarked(destination.id);
            return IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                provider.toggleBookmark(destination);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isBookmarked
                          ? 'Dihapus dari Bookmark'
                          : 'Disimpan ke Bookmark',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              destination.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                color: const Color(0xFFE2E8F0),
                child: const Icon(Icons.broken_image,
                    color: Colors.white70, size: 64),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(120),
                    Colors.transparent,
                    Colors.black.withAlpha(100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  destination.category,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF1D4ED8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFFCD400), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${destination.rating}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF191C21),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' (${destination.reviews})',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            destination.name,
            style: AppTextStyles.h3.copyWith(
              color: const Color(0xFF191C21),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final query = Uri.encodeComponent('${destination.name} ${destination.location}');
              final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
              try {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tidak dapat membuka peta')),
                  );
                }
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.location_on,
                      color: Color(0xFF94A3B8), size: 18),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      destination.location,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            destination.description,
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF424752),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaktaMenarik() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Fakta Menarik',
            style: AppTextStyles.h4.copyWith(
              color: const Color(0xFF191C21),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 196,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: destination.facts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final fact = destination.facts[index];
              return Container(
                width: 280,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFC2C6D4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? const Color(0xFFFFDBCC)
                            : const Color(0xFFFFE16D),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        index % 2 == 0 ? Icons.lightbulb : Icons.museum,
                        color: index % 2 == 0
                            ? const Color(0xFF973C00)
                            : const Color(0xFF6E5C00),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fakta ${index + 1}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF191C21),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.7,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        fact,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: const Color(0xFF424752),
                          height: 1.6,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLokasi(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lokasi',
            style: AppTextStyles.h4.copyWith(
              color: const Color(0xFF191C21),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final query = Uri.encodeComponent('${destination.name} ${destination.location}');
              final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
              try {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tidak dapat membuka peta')),
                  );
                }
              }
            },
            child: Container(
              height: 192,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFFE2E8F0),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=600&auto=format&fit=crop',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stack) => Container(
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final relatedQuiz = destination.quizId != null
        ? MockQuizzes.getQuizzes().firstWhere(
            (q) => q.id == destination.quizId,
            orElse: () => MockQuizzes.getQuizzes().first,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x140056B3),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Harga Tiket',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      destination.ticketPrice,
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Consumer<BookmarkProvider>(
                  builder: (context, provider, child) {
                    final isBookmarked = provider.isBookmarked(destination.id);
                    return GestureDetector(
                      onTap: () => provider.toggleBookmark(destination),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isBookmarked
                              ? AppColors.primary.withAlpha(20)
                              : const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked
                              ? AppColors.primary
                              : const Color(0xFF94A3B8),
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            if (relatedQuiz != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<QuizProvider>().startQuiz(relatedQuiz);
                  context.push('/quiz-play');
                },
                icon: const Icon(Icons.quiz_rounded, color: Colors.white),
                label: Text(
                  'Mulai Kuis: ${relatedQuiz.title}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
