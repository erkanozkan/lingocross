import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../classes/data/dtos/class_dtos.dart';
import '../../../classes/presentation/classes_notifier.dart';
import '../../../classes/presentation/widgets/class_badge.dart';
import '../../data/dtos/game_dtos.dart';
import '../../domain/games_failure.dart';
import '../games_failure_messages.dart';
import '../question_topics_notifier.dart';

/// Çıkmış Sorular Listesi (Öğretmen) — Stitch `67ea9b58…` temelli.
///
/// Atanabilir soru konuları listelenir (hero başlık + konu kartları: ikon,
/// başlık, soru sayısı rozeti). Her kartta "Sınıfa Ata" → mevcut sınıf
/// çoklu-seçim atama deseni (bottom-sheet) ile konu seçili sınıflara atanır
/// (`POST /question-topics/{id}/assignments`). Stitch'in alt nav'ı + öğrenciye
/// özgü "Haftalık Performans"/seri kartı UYGULANMAZ (öğretmen akışı).
class QuestionTopicsScreen extends ConsumerWidget {
  const QuestionTopicsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final topicsAsync = ref.watch(questionTopicsNotifierProvider);

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
          l10n.questionTopicsTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(questionTopicsNotifierProvider.notifier).refresh(),
        child: topicsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, _) => _ErrorView(
            message: gamesFailureMessage(error, l10n),
            onRetry: () =>
                ref.read(questionTopicsNotifierProvider.notifier).refresh(),
          ),
          data: (topics) => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.lg,
              AppSpacing.marginMobile,
              AppSpacing.xl,
            ),
            children: [
              const _Hero(),
              const SizedBox(height: AppSpacing.xl),
              if (topics.isEmpty)
                const _EmptyView()
              else
                for (final topic in topics) ...[
                  _TopicCard(
                    topic: topic,
                    onAssign: () => _openAssignSheet(context, ref, topic),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAssignSheet(
    BuildContext context,
    WidgetRef ref,
    QuestionTopicDto topic,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => _AssignSheet(topic: topic),
    );
  }
}

/// Hero başlık — Stitch §hero (primary-container kart + school ikon).
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.level2,
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            right: -16,
            bottom: -24,
            child: Icon(
              Icons.school,
              size: 120,
              color: AppColors.onPrimary.withValues(alpha: 0.18),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.questionTopicsHeroTitle,
                style: AppTypography.headlineLg
                    .copyWith(color: AppColors.onPrimary),
              ),
              const SizedBox(height: AppSpacing.xs),
              SizedBox(
                width: 240,
                child: Text(
                  l10n.questionTopicsHeroSubtitle,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tek bir konu kartı — Stitch §exam list item (ikon kutusu + başlık + soru
/// sayısı + "Sınıfa Ata" pill).
class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.topic, required this.onAssign});

  final QuestionTopicDto topic;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(Icons.history_edu,
                color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: AppTypography.headlineMd,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.base),
                Row(
                  children: [
                    const Icon(Icons.quiz,
                        size: 16, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.base),
                    Text(
                      l10n.questionTopicsQuestionCount(topic.questionCount),
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton(
            onPressed: onAssign,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            child: Text(
              l10n.questionTopicsAssign,
              style: AppTypography.labelLg,
            ),
          ),
        ],
      ),
    );
  }
}

/// Konu atama bottom-sheet'i — sınıf çoklu seçimi + "Ata" (≥1 sınıf gerekli).
class _AssignSheet extends ConsumerStatefulWidget {
  const _AssignSheet({required this.topic});

  final QuestionTopicDto topic;

  @override
  ConsumerState<_AssignSheet> createState() => _AssignSheetState();
}

class _AssignSheetState extends ConsumerState<_AssignSheet> {
  final Set<String> _selected = {};
  bool _seeded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final classesAsync = ref.watch(classesNotifierProvider);
    // Mevcut atamaları bir kez ön-seç (sheet açılınca işaretli gelir).
    final assignmentsAsync =
        ref.watch(topicAssignmentsProvider(widget.topic.id));
    assignmentsAsync.whenData((a) {
      if (!_seeded) {
        _seeded = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selected.addAll(a.classIds));
        });
      }
    });
    final busy = ref.watch(setTopicAssignmentsControllerProvider).isLoading;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.marginMobile,
          right: AppSpacing.marginMobile,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.questionTopicsAssignSheetTitle,
              style: AppTypography.headlineMd,
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              widget.topic.title,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            Flexible(
              child: SingleChildScrollView(
                child: classesAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    ),
                  ),
                  error: (_, __) => Text(
                    l10n.createGameClassesError,
                    style:
                        AppTypography.bodyMd.copyWith(color: AppColors.error),
                  ),
                  data: (classes) {
                    if (classes.isEmpty) {
                      return Text(
                        l10n.createGameClassesEmpty,
                        style: AppTypography.bodyMd
                            .copyWith(color: AppColors.onSurfaceVariant),
                      );
                    }
                    return Column(
                      children: [
                        for (final c in classes) ...[
                          _ClassSelectRow(
                            classDto: c,
                            selected: _selected.contains(c.id),
                            onTap: () => setState(() {
                              if (!_selected.add(c.id)) _selected.remove(c.id);
                            }),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: (_selected.isEmpty || busy) ? null : _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
              child: busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.onPrimary),
                    )
                  : Text(l10n.questionTopicsAssignSubmit,
                      style: AppTypography.labelLg),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref
        .read(setTopicAssignmentsControllerProvider.notifier)
        .setAssignments(
          topicId: widget.topic.id,
          classIds: _selected.toList(),
        );
    if (!mounted) return;
    if (result != null) {
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.questionTopicsAssignSuccess)),
      );
    } else {
      final error = ref.read(setTopicAssignmentsControllerProvider).error;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            error is GamesFailure
                ? gamesFailureMessage(error, l10n)
                : l10n.commonErrorGeneric,
          ),
        ),
      );
    }
  }
}

/// Atama sheet'inde tek bir sınıf satırı (create_game deseni — checkbox).
class _ClassSelectRow extends StatelessWidget {
  const _ClassSelectRow({
    required this.classDto,
    required this.selected,
    required this.onTap,
  });

  final ClassDto classDto;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.outlineVariant,
              width: selected ? 2 : 1,
            ),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  classBadgeLabel(classDto.name),
                  style: AppTypography.labelLg
                      .copyWith(color: AppColors.onSecondary),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classDto.name,
                      style: AppTypography.headlineMd,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      l10n.classesStudentCount(classDto.studentCount),
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              _Checkbox(checked: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: checked ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: checked ? AppColors.primary : AppColors.outlineVariant,
          width: 2,
        ),
      ),
      child: checked
          ? const Icon(Icons.check, color: AppColors.onPrimary, size: 16)
          : null,
    );
  }
}

/// Boş durum — atanabilir konu yok.
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history_edu,
                color: AppColors.primary, size: 36),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.questionTopicsEmpty,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Yükleme hatası görünümü (tekrar dene).
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 40, color: AppColors.error),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}
