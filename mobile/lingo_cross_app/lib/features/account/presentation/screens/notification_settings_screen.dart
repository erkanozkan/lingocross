import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/auth_notifier.dart';
import '../../data/notification_prefs.dart';

/// Bildirim Ayarları (Stitch `a814e0d9…` — birebir). Hesap Ayarları'ndan
/// push'lanır (`/account/notifications`).
///
/// Üstte ana anahtar kartı + üç grup (ÖDEV & BULMACA / SONUÇLAR / GENEL) +
/// "Sessiz Saatler" bilgi kartı. Toggle durumları cihazda saklanır
/// (`NotificationPrefs`); ana anahtar kapalıyken alt satırlar soluk/pasif.
/// Push altyapısı YOK — şimdilik yalnız tercih kaydı. "Şimdi Ayarla" → Yakında.
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  late Map<NotificationToggle, bool> _values;

  @override
  void initState() {
    super.initState();
    _values = ref.read(notificationPrefsProvider).readAll();
  }

  void _set(NotificationToggle toggle, bool value) {
    setState(() => _values[toggle] = value);
    ref.read(notificationPrefsProvider).write(toggle, value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final master = _values[NotificationToggle.master] ?? true;
    final isTeacher =
        ref.watch(authNotifierProvider).user?.role.isTeacher ?? false;

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
          l10n.notificationSettingsTitle,
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
          // Ana anahtar kartı.
          _MasterCard(
            title: l10n.notificationMasterTitle,
            desc: l10n.notificationMasterDesc,
            value: master,
            onChanged: (v) => _set(NotificationToggle.master, v),
          ),
          const SizedBox(height: AppSpacing.lg),
          // ÖDEV & BULMACA
          _ToggleGroup(
            title: l10n.notificationGroupAssignments,
            enabled: master,
            rows: [
              _ToggleRowData(
                title: l10n.notificationAssignedTitle,
                desc: l10n.notificationAssignedDesc,
                value: _values[NotificationToggle.assigned] ?? true,
                onChanged: (v) => _set(NotificationToggle.assigned, v),
              ),
              _ToggleRowData(
                title: l10n.notificationReminderTitle,
                desc: l10n.notificationReminderDesc,
                value: _values[NotificationToggle.reminder] ?? true,
                onChanged: (v) => _set(NotificationToggle.reminder, v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // SONUÇLAR
          _ToggleGroup(
            title: l10n.notificationGroupResults,
            enabled: master,
            rows: [
              _ToggleRowData(
                title: isTeacher
                    ? l10n.notificationResultTeacherTitle
                    : l10n.notificationResultStudentTitle,
                value: _values[NotificationToggle.results] ?? true,
                onChanged: (v) => _set(NotificationToggle.results, v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // GENEL
          _ToggleGroup(
            title: l10n.notificationGroupGeneral,
            enabled: master,
            rows: [
              _ToggleRowData(
                title: l10n.notificationAnnouncementsTitle,
                value: _values[NotificationToggle.announcements] ?? false,
                onChanged: (v) => _set(NotificationToggle.announcements, v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Sessiz Saatler bilgi kartı.
          _QuietHoursCard(
            title: l10n.notificationQuietHoursTitle,
            desc: l10n.notificationQuietHoursDesc,
            cta: l10n.notificationQuietHoursCta,
            onTap: () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(l10n.commonComingSoon))),
          ),
        ],
      ),
    );
  }
}

/// Ana anahtar kartı (surface-container, başlık + açıklama + Switch).
class _MasterCard extends StatelessWidget {
  const _MasterCard({
    required this.title,
    required this.desc,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String desc;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: AppShadows.soft,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headlineMd),
                const SizedBox(height: AppSpacing.base),
                Text(
                  desc,
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _LuminaSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ToggleRowData {
  const _ToggleRowData({
    required this.title,
    required this.value,
    required this.onChanged,
    this.desc,
  });

  final String title;
  final String? desc;
  final bool value;
  final ValueChanged<bool> onChanged;
}

/// Başlıklı (uppercase, primary) toggle grubu. [enabled] false iken satırlar
/// soluk (opacity 0.4) + pasif.
class _ToggleGroup extends StatelessWidget {
  const _ToggleGroup({
    required this.title,
    required this.rows,
    required this.enabled,
  });

  final String title;
  final List<_ToggleRowData> rows;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.base),
          child: Text(
            title,
            style: AppTypography.labelLg.copyWith(
              color: AppColors.primary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Opacity(
          opacity: enabled ? 1 : 0.4,
          child: IgnorePointer(
            ignoring: !enabled,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var i = 0; i < rows.length; i++) ...[
                    if (i > 0)
                      Divider(
                        height: 1,
                        color: AppColors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    _ToggleRow(data: rows[i]),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.data});

  final _ToggleRowData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: AppTypography.bodyLg
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                if (data.desc != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    data.desc!,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _LuminaSwitch(value: data.value, onChanged: data.onChanged),
        ],
      ),
    );
  }
}

/// Sessiz Saatler bilgi kartı (primary-container/10 zemin + ikon + buton).
class _QuietHoursCard extends StatelessWidget {
  const _QuietHoursCard({
    required this.title,
    required this.desc,
    required this.cta,
    required this.onTap,
  });

  final String title;
  final String desc;
  final String cta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -16,
            bottom: -16,
            child: Icon(
              Icons.notifications_paused_outlined,
              size: 120,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.headlineMd
                      .copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: AppSpacing.sm),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Text(
                    desc,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                  child: Text(cta, style: AppTypography.labelLg),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lumina anahtar (track outline → primary, 44×24, beyaz topuz 20px).
class _LuminaSwitch extends StatelessWidget {
  const _LuminaSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      activeTrackColor: AppColors.primary,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: AppColors.outline,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
