import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/dtos/enrollment_dtos.dart';
import '../enrollments_notifier.dart';
import '../invite_code_notifier.dart';

/// Öğretmen Davet Kodu & Öğrenci Listesi (teacher-invite-code.md).
///
/// Davet kodunu görüntüler + kopyala + yeni kod; katılan öğrencileri listeler
/// (ad + katılım tarihi). Onay/accept butonu YOK (katılım doğrudan Active).
/// Detaylı istatistik M6 — burada yok. Öğretmen panelindeki "Öğrenci Gelişimi"
/// kartından açılır.
class TeacherStudentsScreen extends ConsumerWidget {
  const TeacherStudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final codeAsync = ref.watch(inviteCodeNotifierProvider);
    final studentsAsync = ref.watch(enrollmentsNotifierProvider);

    Future<void> refreshAll() async {
      await Future.wait([
        ref.read(inviteCodeNotifierProvider.notifier).refresh(),
        ref.read(enrollmentsNotifierProvider.notifier).refresh(),
      ]);
    }

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
          l10n.teacherStudentsAppBarTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshAll,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.md,
            AppSpacing.marginMobile,
            AppSpacing.xl,
          ),
          children: [
            _InviteCodeSection(codeAsync: codeAsync),
            const SizedBox(height: AppSpacing.lg),
            _StudentsSection(studentsAsync: studentsAsync),
          ],
        ),
      ),
    );
  }
}

class _InviteCodeSection extends ConsumerWidget {
  const _InviteCodeSection({required this.codeAsync});

  final AsyncValue<InviteCodeDto> codeAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return codeAsync.when(
      loading: () => Container(
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      error: (_, __) => _CodeError(
        onRetry: () => ref.read(inviteCodeNotifierProvider.notifier).refresh(),
      ),
      data: (dto) => _InviteCodeCard(
        code: dto.code,
        onCopy: () => _copy(context, l10n, dto.code),
        onShare: () => _share(context, l10n, dto.code),
        onRegenerate: () => _regenerate(context, ref, l10n),
      ),
    );
  }

  Future<void> _copy(
      BuildContext context, AppLocalizations l10n, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.teacherStudentsCopied)));
  }

  // share_plus paketi yok; davet metni panoya kopyalanır (graceful fallback).
  Future<void> _share(
      BuildContext context, AppLocalizations l10n, String code) async {
    await Clipboard.setData(
        ClipboardData(text: l10n.teacherStudentsShareMessage(code)));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.teacherStudentsShareCopied)));
  }

  Future<void> _regenerate(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l10n.teacherStudentsRegenerateConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.commonContinue),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await ref.read(inviteCodeNotifierProvider.notifier).regenerate();
    messenger.showSnackBar(
      SnackBar(
        content: Text(ok
            ? l10n.teacherStudentsRegenerated
            : l10n.teacherStudentsRegenerateError),
      ),
    );
  }
}

class _InviteCodeCard extends StatelessWidget {
  const _InviteCodeCard({
    required this.code,
    required this.onCopy,
    required this.onShare,
    required this.onRegenerate,
  });

  final String code;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onRegenerate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.level2,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.teacherStudentsCodeLabel.toUpperCase(),
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        label: l10n.teacherStudentsCodeSemantic(
                            code.split('').join(' ')),
                        child: Text(
                          code,
                          style: AppTypography.displayLgMobile.copyWith(
                            color: AppColors.onPrimary,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ),
                    _RoundIconButton(
                      icon: Icons.content_copy,
                      tooltip: l10n.teacherStudentsCopy,
                      onTap: onCopy,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.teacherStudentsCodeDesc,
                  style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerLowest,
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: onShare,
                        icon: const Icon(Icons.share, size: 18),
                        label: Text(l10n.teacherStudentsShare),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.onPrimary,
                          side: BorderSide(
                              color: AppColors.onPrimary.withValues(alpha: 0.4)),
                        ),
                        onPressed: onRegenerate,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(l10n.teacherStudentsRegenerate),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.onPrimary.withValues(alpha: 0.2),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, color: AppColors.onPrimary, size: 20),
          ),
        ),
      ),
    );
  }
}

class _StudentsSection extends ConsumerWidget {
  const _StudentsSection({required this.studentsAsync});

  final AsyncValue<List<EnrollmentDto>> studentsAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return studentsAsync.when(
      loading: () => Column(
        children: List.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
            ),
          ),
        ),
      ),
      error: (_, __) => _ListError(
        onRetry: () =>
            ref.read(enrollmentsNotifierProvider.notifier).refresh(),
      ),
      data: (all) {
        // Yalnız aktif öğrenciler (doğrudan-Active; pending/rejected gizli).
        final students = all.where((e) => e.status.isActive).toList()
          ..sort((a, b) => a.counterpartDisplayName
              .toLowerCase()
              .compareTo(b.counterpartDisplayName.toLowerCase()));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l10n.teacherStudentsListTitle,
                    style: AppTypography.headlineMd),
                const SizedBox(width: AppSpacing.xs),
                if (students.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs, vertical: AppSpacing.base),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      l10n.teacherStudentsCount(students.length),
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (students.isEmpty)
              const _EmptyStudents()
            else
              for (final s in students) ...[
                _StudentRow(enrollment: s),
                const SizedBox(height: AppSpacing.sm),
              ],
          ],
        );
      },
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.enrollment});

  final EnrollmentDto enrollment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = enrollment.counterpartDisplayName;
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
    final date = _formatDate(enrollment.createdAt);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Text(initial,
                style: AppTypography.labelLg.copyWith(color: AppColors.primary)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: AppTypography.labelLg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppSpacing.base),
                Text(
                  l10n.teacherStudentsJoinedAt(date),
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs, vertical: AppSpacing.base),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              l10n.teacherStudentsStatusActive,
              style: AppTypography.labelSm.copyWith(color: AppColors.tertiary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd.$mm.${d.year}';
  }
}

class _EmptyStudents extends StatelessWidget {
  const _EmptyStudents();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          const Icon(Icons.group, color: AppColors.primary, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.teacherStudentsEmptyTitle,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.teacherStudentsEmptyDesc,
            textAlign: TextAlign.center,
            style:
                AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _CodeError extends StatelessWidget {
  const _CodeError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _ErrorCardBase(title: l10n.teacherStudentsErrorCode, onRetry: onRetry);
  }
}

class _ListError extends StatelessWidget {
  const _ListError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _ErrorCardBase(title: l10n.teacherStudentsErrorList, onRetry: onRetry);
  }
}

class _ErrorCardBase extends StatelessWidget {
  const _ErrorCardBase({required this.title, required this.onRetry});

  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off, color: AppColors.error, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(title,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}
