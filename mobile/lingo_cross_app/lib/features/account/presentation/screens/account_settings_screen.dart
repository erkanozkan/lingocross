import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/auth_failure_messages.dart';
import '../../../auth/presentation/auth_notifier.dart';
import '../widgets/change_password_sheet.dart';
import '../widgets/edit_profile_sheet.dart';

/// Hesap Ayarları (Stitch `cd1f1f71…` — birebir). Profilden push'lanır
/// (`/account/settings`), her iki rol erişir.
///
/// Profil başlığı (avatar + ad + e-posta + "Profili Düzenle") + üç ayar grubu:
/// GENEL (Bildirim/Dil=Türkçe/Tema=Açık → "Yakında"), GÜVENLİK (Şifre
/// Değiştir=GERÇEK, İki Faktörlü=placeholder), DESTEK & HAKKINDA (Yardım,
/// Gizlilik=placeholder); kırmızı Çıkış Yap=gerçek logout; altta sürüm satırı.
/// Stitch'teki alt nav UYGULANMAZ (mevcut nav korunur).
class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authNotifierProvider).user;
    final name = user?.displayName ?? '';
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.accountSettingsTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.marginMobile,
          AppSpacing.md,
          AppSpacing.marginMobile,
          AppSpacing.xl,
        ),
        children: [
          _ProfileHeader(
            name: name,
            email: email,
            onEdit: () => EditProfileSheet.show(context, initialName: name),
          ),
          const SizedBox(height: AppSpacing.xl),
          // GENEL
          _SettingsGroup(
            title: l10n.accountGroupGeneral,
            rows: [
              _SettingsRowData(
                icon: Icons.notifications_outlined,
                label: l10n.accountRowNotifications,
                onTap: () => context.push(AppRoutes.accountNotifications),
              ),
              _SettingsRowData(
                icon: Icons.language,
                label: l10n.accountRowLanguage,
                subtitle: l10n.langTurkish,
                onTap: () => context.push(AppRoutes.accountLanguage),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // GÜVENLİK
          _SettingsGroup(
            title: l10n.accountGroupSecurity,
            rows: [
              _SettingsRowData(
                icon: Icons.lock_outline,
                label: l10n.accountRowChangePassword,
                onTap: () => ChangePasswordSheet.show(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // DESTEK & HAKKINDA
          _SettingsGroup(
            title: l10n.accountGroupSupport,
            rows: [
              _SettingsRowData(
                icon: Icons.help_outline,
                label: l10n.accountRowHelpCenter,
                onTap: () => context.push(AppRoutes.accountHelp),
              ),
              _SettingsRowData(
                icon: Icons.description_outlined,
                label: l10n.accountRowPrivacy,
                onTap: () => context.push(AppRoutes.accountPrivacy),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // TEHLİKELİ BÖLGE — yıkıcı hesap silme.
          const _DangerZone(),
          const SizedBox(height: AppSpacing.lg),
          _LogoutButton(
            onTap: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
          const SizedBox(height: AppSpacing.xs),
          const _VersionLine(),
        ],
      ),
    );
  }
}

/// Avatar (baş harf) + ad + e-posta + "Profili Düzenle" düğmesi.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.onEdit,
  });

  final String name;
  final String email;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 96,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 4),
                boxShadow: AppShadows.level2,
              ),
              child: Text(
                initial,
                style: AppTypography.displayLgMobile
                    .copyWith(color: AppColors.primary),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: AppColors.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onEdit,
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.xs),
                    child: Icon(Icons.edit, size: 18, color: AppColors.onPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(name, style: AppTypography.headlineLg),
        const SizedBox(height: AppSpacing.xs),
        Text(
          email,
          style: AppTypography.bodyMd.copyWith(color: AppColors.outline),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: onEdit,
          child: Text(
            l10n.accountEditProfileCta,
            style: AppTypography.labelLg.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _SettingsRowData {
  const _SettingsRowData({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
}

/// Başlıklı (uppercase) ayar grubu kartı — Stitch'teki gruplama.
class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.rows});

  final String title;
  final List<_SettingsRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              title,
              style: AppTypography.labelSm.copyWith(
                color: AppColors.outline,
                letterSpacing: 0.6,
              ),
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, color: AppColors.outlineVariant),
            _SettingsRow(data: rows[i]),
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.data});

  final _SettingsRowData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(data.icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.label,
                      style: AppTypography.bodyMd
                          .copyWith(color: AppColors.onSurface)),
                  if (data.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle!,
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.outline),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}

/// TEHLİKELİ BÖLGE — yıkıcı "Hesabı Sil" satırı (kırmızı). Tıklayınca onay
/// diyaloğu açar; onaylanırsa hesabı siler (DELETE /auth/me) ve oturumu kapatır.
/// Silme sırasında satır disable + spinner; hata olursa SnackBar gösterir,
/// oturum korunur (router auth state korunduğu için ekranda kalır).
class _DangerZone extends ConsumerStatefulWidget {
  const _DangerZone();

  @override
  ConsumerState<_DangerZone> createState() => _DangerZoneState();
}

class _DangerZoneState extends ConsumerState<_DangerZone> {
  bool _deleting = false;

  Future<void> _onTap() async {
    if (_deleting) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dl10n = AppLocalizations.of(dialogContext);
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          title: Text(
            dl10n.accountDeleteDialogTitle,
            style: AppTypography.headlineMd.copyWith(color: AppColors.error),
          ),
          content: Text(
            dl10n.accountDeleteDialogBody,
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                dl10n.accountDeleteCancel,
                style: AppTypography.labelLg
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                dl10n.accountDeleteConfirm,
                style: AppTypography.labelLg.copyWith(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await ref.read(authNotifierProvider.notifier).deleteAccount();
      // Başarı: state `unauthenticated` → router girişe yönlendirir.
    } catch (failure) {
      if (!mounted) return;
      setState(() => _deleting = false);
      messenger.showSnackBar(
        SnackBar(content: Text(authFailureMessage(failure, l10n))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              l10n.accountGroupDangerZone,
              style: AppTypography.labelSm.copyWith(
                color: AppColors.error,
                letterSpacing: 0.6,
              ),
            ),
          ),
          InkWell(
            onTap: _deleting ? null : _onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: const Icon(Icons.person_off,
                        color: AppColors.error, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      l10n.accountRowDeleteAccount,
                      style: AppTypography.bodyMd
                          .copyWith(color: AppColors.error),
                    ),
                  ),
                  if (_deleting)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.error,
                      ),
                    )
                  else
                    const Icon(Icons.chevron_right, color: AppColors.error),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: AppColors.error),
            const SizedBox(width: AppSpacing.xs),
            Text(
              l10n.accountLogout,
              style: AppTypography.headlineMd.copyWith(color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sürüm satırı (package_info_plus).
class _VersionLine extends StatelessWidget {
  const _VersionLine();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version ?? '';
        return Center(
          child: Text(
            version.isEmpty
                ? l10n.appName
                : l10n.accountVersion(version),
            style: AppTypography.labelSm
                .copyWith(color: AppColors.outline.withValues(alpha: 0.6)),
          ),
        );
      },
    );
  }
}
