import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'providers/auth_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'tag': 'Budaya & Sejarah',
      'title': 'Jelajahi 20 Destinasi\nWisata Jakarta',
      'subtitle':
          'Dari museum bersejarah, taman kota, hingga kawasan religi — semua dalam satu aplikasi.',
      'image': 'assets/images/onboarding1.png',
    },
    {
      'tag': 'Kuis Interaktif',
      'title': 'Uji Wawasanmu\ntentang Jakarta',
      'subtitle':
          'Jawab 100 pertanyaan seru, kumpulkan poin, dan lihat posisimu di leaderboard.',
      'image': 'assets/images/onboarding2.png',
    },
    {
      'tag': 'AI GUIDE',
      'title': 'Tanya Apa Saja\ntentang Jakarta',
      'subtitle':
          'JakartaGuide AI siap membantu —dari rekomendasi tempat hingga info tiket dan jam buka.',
      'image': 'assets/images/onboarding3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  _pages[_currentIndex]['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                  ), // Fallback if image not yet added
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withAlpha(0),
                        Colors.black.withAlpha(100),
                        Colors.black.withAlpha(200),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Language Pill
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                'Bahasa Indonesia',
                style: AppTextStyles.body.copyWith(color: Colors.white),
              ),
            ),
          ),

          // Bottom Card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.52,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      onPageChanged: (index) =>
                          setState(() => _currentIndex = index),
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Text(
                                  _pages[index]['tag']!.toUpperCase(),
                                  style: AppTextStyles.caption.copyWith(
                                    color: Colors.white,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _pages[index]['title']!,
                                style: AppTextStyles.display.copyWith(
                                  fontSize: 24,
                                  height: 1.25,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _pages[index]['subtitle']!,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Indicator and Buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      children: [
                        SmoothPageIndicator(
                          controller: _controller,
                          count: _pages.length,
                          effect: const ExpandingDotsEffect(
                            activeDotColor: AppColors.secondary,
                            dotColor: Color(0xFFC8C5CD),
                            dotHeight: 8,
                            dotWidth: 8,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_currentIndex == _pages.length - 1) {
                                context.push('/register');
                              } else {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Text(
                              _currentIndex == _pages.length - 1
                                  ? 'Mulai Jelajahi'
                                  : 'Mulai Jelajahi',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_currentIndex < _pages.length - 1)
                          TextButton(
                            onPressed: () async {
                              await context
                                  .read<AuthProvider>()
                                  .finishOnboarding();
                              if (context.mounted) {
                                context.go('/login');
                              }
                            },
                            child: Text(
                              'Lewati',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sudah punya akun? ',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await context
                                      .read<AuthProvider>()
                                      .finishOnboarding();
                                  if (context.mounted) {
                                    context.go('/login');
                                  }
                                },
                                child: Text(
                                  'Masuk',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
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
}
