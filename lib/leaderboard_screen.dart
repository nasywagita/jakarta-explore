import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/auth_provider.dart';
import 'data/services/database_service.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final int totalPoints = auth.user?.totalPoints ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseService().getLeaderboard(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final leaderboardData = snapshot.data ?? [];
            final currentUser = context.read<AuthProvider>().user;
            
            // Find current user's rank
            int currentRank = -1;
            for (int i = 0; i < leaderboardData.length; i++) {
              if (leaderboardData[i]['id'] == currentUser?.id) {
                currentRank = i + 1;
                break;
              }
            }

            return Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        if (leaderboardData.isNotEmpty)
                          _buildTop3Podium(leaderboardData),
                        const SizedBox(height: 32),
                        if (leaderboardData.length > 3)
                          _buildRankList(leaderboardData.sublist(3)),
                      ],
                    ),
                  ),
                ),
                _buildCurrentUserRank(totalPoints, currentRank),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF424752)),
                onPressed: () {
                  context.read<QuizProvider>().reset();
                  context.go('/'); // go back to home
                },
              ),
              Text(
                'Papan Peringkat',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final name = auth.user?.name ?? 'User';
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD7E2FF), width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    "https://ui-avatars.com/api/?name=$name&background=0D8ABC&color=fff",
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTop3Podium(List<Map<String, dynamic>> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (data.length > 1)
            _buildPodiumItem(
              name: data[1]['name'] ?? 'User',
              points: data[1]['totalPoints'] ?? 0,
              rank: 2,
              height: 140,
              color: const Color(0xFFC0C0C0), // Silver
              avatarUrl: data[1]['profileImage'] ??
                  "https://ui-avatars.com/api/?name=${Uri.encodeComponent(data[1]['name'] ?? 'U')}&background=C0C0C0&color=fff",
            )
          else
            const SizedBox(width: 88),
          
          const SizedBox(width: 16),
          
          if (data.isNotEmpty)
            _buildPodiumItem(
              name: data[0]['name'] ?? 'User',
              points: data[0]['totalPoints'] ?? 0,
              rank: 1,
              height: 180,
              color: const Color(0xFFFFD700), // Gold
              avatarUrl: data[0]['profileImage'] ??
                  "https://ui-avatars.com/api/?name=${Uri.encodeComponent(data[0]['name'] ?? 'U')}&background=FFD700&color=fff",
            ),
          
          const SizedBox(width: 16),
          
          if (data.length > 2)
            _buildPodiumItem(
              name: data[2]['name'] ?? 'User',
              points: data[2]['totalPoints'] ?? 0,
              rank: 3,
              height: 120,
              color: const Color(0xFFCD7F32), // Bronze
              avatarUrl: data[2]['profileImage'] ??
                  "https://ui-avatars.com/api/?name=${Uri.encodeComponent(data[2]['name'] ?? 'U')}&background=CD7F32&color=fff",
            )
          else
            const SizedBox(width: 88),
        ],
      ),
    );
  }

  Widget _buildPodiumItem({
    required String name,
    required int points,
    required int rank,
    required double height,
    required Color color,
    required String avatarUrl,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
                image: DecorationImage(
                  image: NetworkImage(avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              child: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$rank',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF191C21),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '$points',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border(
              top: BorderSide(color: color, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankList(List<Map<String, dynamic>> restOfData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: List.generate(restOfData.length, (index) {
          final data = restOfData[index];
          return _buildRankListItem(
            rank: index + 4, // Starts from 4th
            name: data['name'] ?? 'User',
            points: data['totalPoints'] ?? 0,
            profileImage: data['profileImage'],
          );
        }),
      ),
    );
  }

  Widget _buildRankListItem({
    required int rank,
    required String name,
    required int points,
    String? profileImage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$rank',
              style: AppTextStyles.bodyLarge.copyWith(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                profileImage ?? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=random',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.bodyLarge.copyWith(
                color: const Color(0xFF191C21),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '$points Poin',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserRank(int score, int currentRank) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 30,
            offset: Offset(0, -8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  final name = auth.user?.name ?? 'User';
                  final avatarUrl = auth.user?.profileImage ??
                      "https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=0D8ABC&color=fff";
                  return Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anda',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: const Color(0xFF191C21),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    currentRank == -1 ? 'Belum Punya Peringkat' : 'Peringkat $currentRank',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              '$score Poin',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
