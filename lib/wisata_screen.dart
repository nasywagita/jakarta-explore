import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'providers/destinations_provider.dart';
import 'providers/auth_provider.dart';
import 'main_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data/models/destination_model.dart';

class WisataScreen extends StatefulWidget {
  const WisataScreen({super.key});

  @override
  State<WisataScreen> createState() => _WisataScreenState();
}

class _WisataScreenState extends State<WisataScreen> {
  final List<String> _filters = [
    'Semua',
    'Budaya & Sejarah',
    'Hiburan & Modern',
    'Alam & Taman',
    'Religi & Spiritual',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilters(),
            Expanded(
              child: Consumer<DestinationsProvider>(
                builder: (context, provider, child) {
                  final items = provider.filteredDestinations;
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 600) {
                        // GridView untuk Tablet/Desktop
                        int crossAxisCount = constraints.maxWidth >= 1000 ? 3 : 2;
                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 80),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return _buildDestinationCard(context, items[index]);
                          },
                        );
                      }
                      
                      // ListView untuk Mobile
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 80),
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 24),
                        itemBuilder: (context, index) {
                          return _buildDestinationCard(context, items[index]);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=Tempat+Wisata+Jakarta');
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
        backgroundColor: const Color(0xFFFFD700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
          side: const BorderSide(color: Color(0xFFE9C400), width: 1),
        ),
        icon: const Icon(Icons.map, color: Color(0xFF6E5C00)),
        label: Text(
          'Peta',
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF6E5C00),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.70,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  Widget _buildFilters() {
    return Consumer<DestinationsProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: 70,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isActive = provider.currentCategory == filter;

              return GestureDetector(
                onTap: () => provider.setCategory(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: isActive ? AppColors.primary : const Color(0xFFC2C6D4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    filter,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isActive ? Colors.white : const Color(0xFF1C1B1D),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDestinationCard(BuildContext context, DestinationModel dest) {
    return GestureDetector(
      onTap: () => context.push('/detail', extra: dest),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 256,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                image: DecorationImage(
                  image: NetworkImage(dest.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(229),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFD700),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dest.rating.toString(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: const Color(0xFF191C21),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                  Text(
                    dest.category.toUpperCase(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dest.name,
                    style: AppTextStyles.h4.copyWith(
                      color: const Color(0xFF191C21),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dest.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF424752),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFF8FAFC), height: 1, thickness: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF64748B),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dest.location.split(',').first, // Showing just the first part for shorter string
                            style: AppTextStyles.bodySmall.copyWith(
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        dest.ticketPrice,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: dest.ticketPrice == 'Gratis'
                              ? const Color(0xFF16A34A) // Green
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.70,
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
    );
  }
}
