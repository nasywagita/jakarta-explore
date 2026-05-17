import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'providers/auth_provider.dart';
import 'providers/bookmark_provider.dart';
import 'providers/destinations_provider.dart';
import 'data/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final user = auth.user;
        final name = user?.name ?? 'Penjelajah';
        final email = user?.email ?? '';
        final score = user?.totalPoints ?? 0;
        final totalQuiz = user?.totalQuizCompleted ?? 0;
        final avatarUrl = user?.profileImage ??
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=0D8ABC&color=fff&size=128';

        final (badgeLabel, badgeColor, badgeTextColor) = _getBadge(score);

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FB),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // ── Header Area ───────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, const Color(0xFF0077CC)],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Profil Saya',
                            style: AppTextStyles.h4.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
                            onPressed: () => _showSettingsSheet(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildAvatar(avatarUrl, name),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: AppTextStyles.h4.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      _buildBadge(badgeLabel, badgeColor, badgeTextColor),
                    ],
                  ),
                ),

                // ── Stats Row ────────────────
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(totalQuiz.toString(), 'Kuis', Icons.quiz_rounded, AppColors.primary),
                        _buildDivider(),
                        _buildStatItem(score.toString(), 'Poin', Icons.stars_rounded, Colors.orange),
                        _buildDivider(),
                        Consumer<BookmarkProvider>(
                          builder: (context, b, _) => _buildStatItem(
                            b.bookmarkedIds.length.toString(),
                            'Simpan',
                            Icons.bookmark_rounded,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Menu List ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('AKUN'),
                      const SizedBox(height: 8),
                      _buildMenuCard([
                        _buildMenuItem(
                          icon: Icons.person_rounded,
                          title: 'Informasi Pribadi',
                          subtitle: name,
                          onTap: () => _showProfileInfoSheet(context, user),
                        ),
                        _buildMenuItem(
                          icon: Icons.email_rounded,
                          title: 'Email',
                          subtitle: email.isNotEmpty ? email : '-',
                          onTap: () => _showProfileInfoSheet(context, user),
                        ),
                      ]),
                      const SizedBox(height: 24),

                      _buildSectionLabel('AKTIVITAS'),
                      const SizedBox(height: 8),
                      _buildMenuCard([
                        _buildMenuItem(
                          icon: Icons.bookmark_rounded,
                          title: 'Wisata Tersimpan',
                          subtitle: 'Lihat koleksi destinasi',
                          onTap: () => _showBookmarkSheet(context),
                        ),
                        _buildMenuItem(
                          icon: Icons.leaderboard_rounded,
                          title: 'Papan Peringkat',
                          subtitle: 'Lihat peringkat penjelajah',
                          onTap: () => context.push('/leaderboard'),
                        ),
                      ]),
                      const SizedBox(height: 24),

                      _buildSectionLabel('LAINNYA'),
                      const SizedBox(height: 8),
                      _buildMenuCard([
                        _buildMenuItem(
                          icon: Icons.help_rounded,
                          title: 'Pusat Bantuan',
                          subtitle: 'FAQ & Bantuan Aplikasi',
                          onTap: () => _showHelpSheet(context),
                        ),
                        _buildMenuItem(
                          icon: Icons.info_rounded,
                          title: 'Tentang Aplikasi',
                          subtitle: 'Info aplikasi JakartaExplore',
                          onTap: () => _showAboutDialog(context),
                        ),
                      ]),
                      const SizedBox(height: 32),

                      _buildLogoutButton(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(String url, String name) {
    return Container(
      width: 90, height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => Container(
            color: AppColors.primary,
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: AppTextStyles.h3.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: textColor, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildDivider() => Container(width: 1, height: 30, color: const Color(0xFFE2E8F0));

  Widget _buildSectionLabel(String label) {
    return Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2));
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, String? subtitle, bool isDestructive = false, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: (isDestructive ? Colors.red : AppColors.primary).withAlpha(20), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: isDestructive ? Colors.red : AppColors.primary, size: 20),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: isDestructive ? Colors.red : null)),
      subtitle: subtitle != null ? Text(subtitle, style: AppTextStyles.caption) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right, size: 20) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _confirmLogout(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text('Keluar dari Akun', style: AppTextStyles.bodyMedium.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar?'),
        content: const Text('Yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () { Navigator.pop(ctx); context.read<AuthProvider>().logout(); context.go('/login'); },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showProfileInfoSheet(BuildContext context, UserModel? user) {
    final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    final joinDate = user != null ? "${months[user.createdAt.month - 1]} ${user.createdAt.year}" : 'Mei 2025';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Informasi Pribadi', style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => _showEditProfileDialog(context, user),
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Text('Ubah'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _infoRow(Icons.person, 'Nama', user?.name ?? '-'),
            const Divider(height: 30),
            _infoRow(Icons.email, 'Email', user?.email ?? '-'),
            const Divider(height: 30),
            _infoRow(Icons.calendar_today, 'Bergabung', joinDate),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, UserModel? user) {
    final nameController = TextEditingController(text: user?.name);
    final emailController = TextEditingController(text: user?.email);
    final imageController = TextEditingController(text: user?.profileImage);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ubah Profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'Link Foto Profil (URL)',
                  hintText: 'https://...',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan link gambar dari internet (Unsplash, dll)',
                style: AppTextStyles.caption.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final success = await context.read<AuthProvider>().updateProfile(
                nameController.text,
                emailController.text,
                profileImage: imageController.text.isNotEmpty ? imageController.text : null,
              );
              if (success) {
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil berhasil diperbarui')),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        ]),
      ],
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pengaturan', style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildMenuItem(icon: Icons.lock, title: 'Ubah Kata Sandi', onTap: () {}),
            _buildMenuItem(icon: Icons.notifications, title: 'Notifikasi', onTap: () {}),
            _buildMenuItem(icon: Icons.delete_forever, title: 'Hapus Akun', isDestructive: true, onTap: () {}),
          ],
        ),
      ),
    );
  }

  void _showBookmarkSheet(BuildContext context) {
    final bookmarkProvider = context.read<BookmarkProvider>();
    final all = context.read<DestinationsProvider>().destinations;
    final saved = all.where((d) => bookmarkProvider.bookmarkedIds.contains(d.id)).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        expand: false,
        builder: (ctx, sc) => ListView.builder(
          controller: sc,
          padding: const EdgeInsets.all(24),
          itemCount: saved.length + 1,
          itemBuilder: (ctx, i) {
            if (i == 0) return Padding(padding: const EdgeInsets.only(bottom: 16), child: Text('Wisata Tersimpan', style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold)));
            final d = saved[i-1];
            return ListTile(
              leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(d.imageUrl, width: 50, height: 50, fit: BoxFit.cover)),
              title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () { Navigator.pop(ctx); context.push('/detail', extra: d); },
            );
          },
        ),
      ),
    );
  }

  void _showHelpSheet(BuildContext context) {
    final faqs = [
      ('Bagaimana cara mendapatkan poin?', 'Jawab kuis dengan benar untuk mendapatkan poin.'),
      ('Apa kegunaan bookmark?', 'Simpan destinasi favoritmu agar mudah ditemukan kembali.'),
      ('Informasi rute tidak muncul?', 'Pastikan koneksi internet stabil atau tanya AI.'),
      ('Bagaimana cara logout?', 'Tombol logout ada di bagian bawah profil.'),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        expand: false,
        builder: (ctx, sc) => ListView.builder(
          controller: sc,
          padding: const EdgeInsets.all(24),
          itemCount: faqs.length + 1,
          itemBuilder: (ctx, i) {
            if (i == 0) return Padding(padding: const EdgeInsets.only(bottom: 16), child: Text('Pusat Bantuan', style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold)));
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(faqs[i-1].$1, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text(faqs[i-1].$2, style: const TextStyle(color: Colors.black54)),
              ]),
            );
          },
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'JakartaExplore',
      applicationVersion: '1.0.0',
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/logo2.png',
          width: 48,
          height: 48,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.explore_rounded,
            color: AppColors.primary,
            size: 48,
          ),
        ),
      ),
      children: const [
        Text('Aplikasi panduan wisata cerdas untuk menjelajahi keindahan, budaya, dan sejarah Jakarta.'),
      ],
    );
  }

  (String, Color, Color) _getBadge(int score) {
    if (score >= 500) return ('🏆 Master Explorer', const Color(0xFFFCD400), const Color(0xFF6E5C00));
    if (score >= 200) return ('🥈 Senior Explorer', const Color(0xFFE2E8F0), const Color(0xFF475569));
    if (score >= 50) return ('🥉 Explorer', const Color(0xFFFFE4CC), const Color(0xFF973C00));
    return ('🌱 Pemula', const Color(0xFFDCFCE7), const Color(0xFF166534));
  }
}
