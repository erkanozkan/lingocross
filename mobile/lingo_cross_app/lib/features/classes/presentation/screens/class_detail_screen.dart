import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/dtos/class_dtos.dart';
import '../class_detail_notifier.dart';
import '../class_invite_code_notifier.dart';

/// Sınıf Detayı (Stitch `f02c6d75…` birebir). Mavi davet kodu kartı
/// (Kopyala / Paylaş / Yeni Kod Üret) + "Öğrenciler (N)" + "Ekle" (davet kodunu
/// paylaş) + öğrenci satırları (baş harf avatar + ad + çöp ikonu → DELETE) +
/// altta altın "Bu Sınıfa Ödev Ata" → CreateGame.
class ClassDetailScreen extends ConsumerWidget {
  const ClassDetailScreen({super.key, required this.classId});

  final String classId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(classDetailNotifierProvider(classId));
    final codeAsync = ref.watch(classInviteCodeNotifierProvider(classId));

    final title = detailAsync.maybeWhen(
      data: (d) => d.name,
      orElse: () => l10n.classDetailFallbackTitle,
    );

    Future<void> refreshAll() async {
      await Future.wait([
        ref.read(classDetailNotifierProvider(classId).notifier).refresh(),
        ref.read(classInviteCodeNotifierProvider(classId).notifier).refresh(),
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
          title,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
            _InviteCodeSection(classId: classId, codeAsync: codeAsync),
            const SizedBox(height: AppSpacing.xl),
            _StudentsSection(classId: classId, detailAsync: detailAsync),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: Border(top: BorderSide(color: AppColors.outlineVariant)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _AssignHomeworkButton(
              onTap: () => context.push(AppRoutes.gameNew),
            ),
          ),
        ),
      ),
    );
  }
}

class _InviteCodeSection extends ConsumerWidget {
  const _InviteCodeSection({required this.classId, required this.codeAsync});

  final String classId;
  final AsyncValue<ClassInviteCodeDto> codeAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return codeAsync.when(
      loading: () => Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      error: (_, __) => _CodeError(
        onRetry: () => ref
            .read(classInviteCodeNotifierProvider(classId).notifier)
            .refresh(),
      ),
      data: (dto) => InviteCodeCard(
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
        .showSnackBar(SnackBar(content: Text(l10n.classDetailCodeCopied)));
  }

  // share_plus paketi yok; davet metni panoya kopyalanır (graceful fallback).
  Future<void> _share(
      BuildContext context, AppLocalizations l10n, String code) async {
    await Clipboard.setData(
        ClipboardData(text: l10n.classDetailShareMessage(code)));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.classDetailShareCopied)));
  }

  Future<void> _regenerate(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l10n.classDetailRegenerateConfirm),
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
    final ok = await ref
        .read(classInviteCodeNotifierProvider(classId).notifier)
        .regenerate();
    messenger.showSnackBar(
      SnackBar(
        content: Text(ok
            ? l10n.classDetailRegenerated
            : l10n.classDetailRegenerateError),
      ),
    );
  }
}

/// Mavi davet kodu kartı (teacher_students_screen `_InviteCodeCard` referansı).
class InviteCodeCard extends StatelessWidget {
  const InviteCodeCard({
    super.key,
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
            right: -16,
            top: -16,
            child: Icon(
              Icons.school,
              size: 120,
              color: AppColors.onPrimaryContainer.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.classDetailCodeLabel.toUpperCase(),
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.onPrimaryContainer.withValues(alpha: 0.9),
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Semantics(
                  label: l10n.classDetailCodeSemantic(code.split('').join(' ')),
                  child: Text(
                    code,
                    style: AppTypography.displayLgMobile.copyWith(
                      color: AppColors.onPrimaryContainer,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerLowest,
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: onCopy,
                        icon: const Icon(Icons.content_copy, size: 18),
                        label: Text(l10n.classDetailCopy),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerLowest,
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: onShare,
                        icon: const Icon(Icons.share, size: 18),
                        label: Text(l10n.classDetailShare),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton.icon(
                  onPressed: onRegenerate,
                  style: TextButton.styleFrom(
                    foregroundColor:
                        AppColors.onPrimaryContainer.withValues(alpha: 0.9),
                  ),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(l10n.classDetailRegenerate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentsSection extends ConsumerWidget {
  const _StudentsSection({required this.classId, required this.detailAsync});

  final String classId;
  final AsyncValue<ClassDetailDto> detailAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return detailAsync.when(
      loading: () => Column(
        children: List.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Container(
              height: 60,
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
            ref.read(classDetailNotifierProvider(classId).notifier).refresh(),
      ),
      data: (detail) {
        final students = detail.students.toList()
          ..sort((a, b) => a.displayName
              .toLowerCase()
              .compareTo(b.displayName.toLowerCase()));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.classDetailStudents(students.length),
                  style: AppTypography.headlineMd,
                ),
                TextButton.icon(
                  onPressed: () => _addHint(context, ref, l10n),
                  icon: const Icon(Icons.person_add, size: 18),
                  label: Text(l10n.classDetailAdd),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (students.isEmpty)
              const _EmptyStudents()
            else
              for (final s in students) ...[
                _StudentRow(
                  member: s,
                  onRemove: () => _confirmRemove(context, ref, l10n, s),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
          ],
        );
      },
    );
  }

  // "Ekle" = davet kodunu paylaşmaya yönlendirme (öğrenciler kodla katılır).
  Future<void> _addHint(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final code = ref.read(classInviteCodeNotifierProvider(classId)).valueOrNull;
    final messenger = ScaffoldMessenger.of(context);
    if (code != null) {
      await Clipboard.setData(
          ClipboardData(text: l10n.classDetailShareMessage(code.code)));
      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.classDetailShareCopied)));
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.classDetailAddHint)));
    }
  }

  Future<void> _confirmRemove(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ClassMemberDto member,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l10n.classDetailRemoveConfirm(member.displayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.classDetailRemove),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await ref
        .read(classDetailNotifierProvider(classId).notifier)
        .removeStudent(member.studentId);
    messenger.showSnackBar(
      SnackBar(
        content: Text(ok
            ? l10n.classDetailRemoved(member.displayName)
            : l10n.classDetailRemoveError),
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.member, required this.onRemove});

  final ClassMemberDto member;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = member.displayName;
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
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
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Text(initial,
                style: AppTypography.labelLg.copyWith(color: AppColors.primary)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              name,
              style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: l10n.classDetailRemove,
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: AppColors.outline),
          ),
        ],
      ),
    );
  }
}

class _AssignHomeworkButton extends StatelessWidget {
  const _AssignHomeworkButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.secondaryContainer,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: const Border(
              bottom:
                  BorderSide(color: AppColors.secondaryFixedDim, width: 3),
            ),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.assignment, color: AppColors.onSecondary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.classDetailAssignHomework,
                style:
                    AppTypography.headlineMd.copyWith(color: AppColors.onSecondary),
              ),
            ],
          ),
        ),
      ),
    );
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
          Text(l10n.classDetailEmptyTitle,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.classDetailEmptyDesc,
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
    return _ErrorCardBase(title: l10n.classDetailErrorCode, onRetry: onRetry);
  }
}

class _ListError extends StatelessWidget {
  const _ListError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _ErrorCardBase(title: l10n.classDetailErrorList, onRetry: onRetry);
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
