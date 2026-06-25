import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/refresh_on_mount.dart';
import '../../../auth/presentation/auth_notifier.dart';
import '../../../classes/data/dtos/class_dtos.dart';
import '../../../classes/presentation/my_classes_notifier.dart';
import '../../../games/data/dtos/game_dtos.dart';
import '../../../games/presentation/assigned_games_notifier.dart';
import '../../../lessons/presentation/widgets/skeleton_card.dart';
import '../../../profile/presentation/student_stats_notifier.dart';
import '../../data/dtos/enrollment_dtos.dart';
import '../enrollments_notifier.dart';
import '../widgets/student_bottom_nav.dart';

/// Öğrenci Paneli (student-dashboard.md — Stitch `55a66eca…` birebir).
///
/// F2.2: oyunlar artık öğretmen tarafından açıkça oluşturulup yayınlanır;
/// öğrenci kendisine **atanmış** bulmacaları görür ve oynar (`GET
/// /games/assigned`). İlk atama "Günün Oyunu" bento-large kartı, kalanlar
/// "Atanan Bulmacalar" listesidir; bir bulmacaya dokununca doğrudan
/// `POST /games/{id}/sessions` ile oturum başlatılır. Boş/yükleniyor/hata
/// durumları + "Öğretmene Katıl" giriş noktası. Faz 2 öğeleri (çıkmış sorular,
/// Sorular nav) gizli; Gelişim Özeti M6 iskeleti olarak "Yakında" gösterilir.
class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final name = ref.watch(authNotifierProvider).user?.displayName ?? '';
    final enrollmentsAsync = ref.watch(enrollmentsNotifierProvider);
    final gamesAsync = ref.watch(assignedGamesNotifierProvider);
    final myClassesAsync = ref.watch(myClassesNotifierProvider);

    Future<void> refreshAll() async {
      await Future.wait([
        ref.read(enrollmentsNotifierProvider.notifier).refresh(),
        ref.read(assignedGamesNotifierProvider.notifier).refresh(),
        ref.read(myClassesNotifierProvider.notifier).refresh(),
      ]);
    }

    return RefreshOnMount(
      onMount: refreshAll,
      child: Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.marginMobile,
        title: Text(
          l10n.appName,
          style: AppTypography.headlineLg.copyWith(color: AppColors.primary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.marginMobile),
            child: _Avatar(
              name: name,
              onTap: () => context.push(AppRoutes.profile),
            ),
          ),
        ],
      ),
      bottomNavigationBar: StudentBottomNav(
        currentIndex: 0,
        onTap: (i) {
          switch (i) {
            case 2:
              context.push(AppRoutes.profile);
            case 1:
              context.push(AppRoutes.studentResults);
            default:
              break;
          }
        },
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
            _Greeting(name: name),
            const SizedBox(height: AppSpacing.lg),
            _MyClassesSection(myClassesAsync: myClassesAsync),
            _Content(
              enrollmentsAsync: enrollmentsAsync,
              gamesAsync: gamesAsync,
              onRetry: refreshAll,
            ),
          ],
        ),
      ),
    ),
    );
  }
}

/// "Sınıflarım" bölümü (DÜZELTME 1) — öğrencinin katıldığı sınıfları
/// (`GET /api/classes/me`) sınıf adı + öğretmen adıyla gösterir.
///
/// Hiç sınıf yoksa kısa bir boş satır gösterilir (öğretmene/sınıfa katıl ipucu
/// dashboard'ın diğer bölümlerinde zaten var). Yükleniyor → ince skeleton;
/// hata → bölüm gizlenir (mevcut UI bozulmasın).
class _MyClassesSection extends StatelessWidget {
  const _MyClassesSection({required this.myClassesAsync});

  final AsyncValue<List<ClassMembershipDto>> myClassesAsync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Hata → bölümü gizle (dashboard'ın geri kalanı bozulmasın).
    if (myClassesAsync.hasError) return const SizedBox.shrink();

    final classes = myClassesAsync.value;

    // İlk yükleme (veri henüz yok) → ince skeleton.
    if (classes == null && myClassesAsync.isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(l10n.studentDashboardMyClassesTitle),
          const SizedBox(height: AppSpacing.sm),
          const SkeletonCard(height: 72),
          const SizedBox(height: AppSpacing.lg),
        ],
      );
    }

    final list = classes ?? const <ClassMembershipDto>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(l10n.studentDashboardMyClassesTitle),
        const SizedBox(height: AppSpacing.sm),
        if (list.isEmpty)
          _ProgressNotice(
            icon: Icons.school_outlined,
            text: l10n.studentDashboardMyClassesEmpty,
          )
        else
          for (final c in list) ...[
            _MyClassRow(membership: c),
            const SizedBox(height: AppSpacing.sm),
          ],
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

/// Tek sınıf satırı: sınıf adı + öğretmen adı (Lumina kart/satır).
class _MyClassRow extends StatelessWidget {
  const _MyClassRow({required this.membership});

  final ClassMembershipDto membership;

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
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.school, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  membership.className,
                  style: AppTypography.headlineMd,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.base),
                Text(
                  l10n.studentDashboardMyClassTeacher(membership.teacherName),
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Enrollment + atanan bulmaca durumlarını birleştirip bölümleri render eder.
class _Content extends StatelessWidget {
  const _Content({
    required this.enrollmentsAsync,
    required this.gamesAsync,
    required this.onRetry,
  });

  final AsyncValue<List<EnrollmentDto>> enrollmentsAsync;
  final AsyncValue<List<AssignedGameDto>> gamesAsync;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Yükleniyor: bento-large + 2 kart skeleton.
    if (enrollmentsAsync.isLoading || gamesAsync.isLoading) {
      return Column(
        children: const [
          SkeletonCard(height: 200),
          SizedBox(height: AppSpacing.lg),
          SkeletonList(count: 2, height: 96),
        ],
      );
    }

    // Hata (herhangi biri): hata kartı + Tekrar Dene.
    if (enrollmentsAsync.hasError || gamesAsync.hasError) {
      return _StateCard(
        icon: Icons.cloud_off,
        iconColor: AppColors.error,
        title: l10n.studentDashboardError,
        action: OutlinedButton(
          onPressed: onRetry,
          child: Text(l10n.commonRetry),
        ),
      );
    }

    final enrollments = enrollmentsAsync.value ?? const [];
    final hasActiveTeacher =
        enrollments.any((e) => e.status.isActive);

    // Boş — hiç öğretmene katılmamış: birincil "Öğretmene Katıl" + boş durum.
    if (!hasActiveTeacher) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _JoinTeacherCard(
            onTap: () => context.push(AppRoutes.studentJoin),
          ),
          const SizedBox(height: AppSpacing.lg),
          _StateCard(
            icon: Icons.group_add,
            iconColor: AppColors.primary,
            title: l10n.studentDashboardEmptyNoTeacherTitle,
            desc: l10n.studentDashboardEmptyNoTeacherDesc,
          ),
        ],
      );
    }

    // Atanan (yayımlanmış) bulmacalar — yeniden eskiye sırala.
    int byNewest(AssignedGameDto a, AssignedGameDto b) {
      final ad = a.publishedAt;
      final bd = b.publishedAt;
      if (ad == null && bd == null) return 0;
      if (ad == null) return 1;
      if (bd == null) return -1;
      return bd.compareTo(ad);
    }

    final allGames = (gamesAsync.value ?? const <AssignedGameDto>[]).toList()
      ..sort(byNewest);

    // Oynanabilir (henüz tamamlanmamış) ile tamamlanmış bulmacaları ayır.
    // Tamamlananlar yalnız istatistik içindir; "atanan" listesinden çıkar.
    final pending = allGames.where((g) => !g.isCompleted).toList();
    // Tamamlanma zamanı varsa ona göre yeniden→eskiye; yoksa yayım sırası.
    final completed = allGames.where((g) => g.isCompleted).toList()
      ..sort((a, b) {
        final ac = a.completedAt;
        final bc = b.completedAt;
        if (ac != null && bc != null) return bc.compareTo(ac);
        if (ac == null && bc == null) return byNewest(a, b);
        if (ac == null) return 1;
        return -1;
      });

    // Boş — öğretmen var, oynanabilir bulmaca yok.
    if (pending.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StateCard(
            icon: Icons.extension,
            iconColor: AppColors.primary,
            title: l10n.studentDashboardEmptyNoPuzzlesTitle,
            desc: l10n.studentDashboardEmptyNoPuzzlesDesc,
          ),
          if (completed.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            _CompletedSection(games: completed),
          ],
          const SizedBox(height: AppSpacing.lg),
          _JoinTeacherLink(onTap: () => context.push(AppRoutes.studentJoin)),
          const SizedBox(height: AppSpacing.lg),
          const _ProgressSummarySection(),
        ],
      );
    }

    final featured = pending.first;
    final rest = pending.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(l10n.studentDashboardGameOfDay),
        const SizedBox(height: AppSpacing.sm),
        _GameOfDayCard(
          game: featured,
          onPlay: () => context.push(AppRoutes.studentGame(featured.id)),
        ),
        if (rest.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.studentDashboardPuzzlesTitle,
              style: AppTypography.headlineMd),
          const SizedBox(height: AppSpacing.sm),
          for (final game in rest) ...[
            _AssignedGameRow(
              game: game,
              onTap: () => context.push(AppRoutes.studentGame(game.id)),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
        if (completed.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _CompletedSection(games: completed),
        ],
        const SizedBox(height: AppSpacing.lg),
        _JoinTeacherLink(onTap: () => context.push(AppRoutes.studentJoin)),
        const SizedBox(height: AppSpacing.lg),
        const _ProgressSummarySection(),
      ],
    );
  }
}

/// "Tamamlanan Bulmacalar" bölümü — tamamlanmış (isCompleted) bulmacalar.
///
/// Tekrar oynanamaz: her satıra dokununca [AppRoutes.studentResultDetail] ile
/// istatistik ekranına gidilir (asla oyun launcher'ına değil). Sonuç gönderimde
/// otomatik paylaşıldığı için ayrıca paylaşma yoktur.
class _CompletedSection extends StatelessWidget {
  const _CompletedSection({required this.games});

  final List<AssignedGameDto> games;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.studentDashboardCompletedTitle,
            style: AppTypography.headlineMd),
        const SizedBox(height: AppSpacing.sm),
        for (final game in games) ...[
          _CompletedGameRow(
            game: game,
            onTap: () {
              final resultId = game.resultId;
              if (resultId == null) return;
              context.push(AppRoutes.studentResultDetail(resultId));
            },
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

/// Tamamlanmış bir bulmaca satırı: ders/bulmaca adı + skor + "İstatistikleri
/// Gör". Dokununca istatistik ekranına gider (replay DEĞİL).
class _CompletedGameRow extends StatelessWidget {
  const _CompletedGameRow({required this.game, required this.onTap});

  final AssignedGameDto game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final score = game.score;
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
            border: Border.all(color: AppColors.outlineVariant),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.check_circle,
                    color: AppColors.tertiary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: AppTypography.headlineMd,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            game.lessonTitle,
                            style: AppTypography.labelSm
                                .copyWith(color: AppColors.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          l10n.studentDashboardCompletedSeeStats,
                          style: AppTypography.labelSm
                              .copyWith(color: AppColors.primary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              if (score != null)
                _ScoreBadge(percent: score)
              else
                _CompletedBadge(label: l10n.studentDashboardCompletedBadge),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tamamlanan bulmacanın skor rozeti (örn. "%85").
class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        l10n.studentDashboardCompletedScore(percent),
        style: AppTypography.labelLg.copyWith(color: AppColors.tertiary),
      ),
    );
  }
}

/// Skor bilinmiyorsa "Tamamlandı" rozeti.
class _CompletedBadge extends StatelessWidget {
  const _CompletedBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(color: AppColors.tertiary),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.studentDashboardGreeting(name),
          style: AppTypography.headlineMd,
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          l10n.studentDashboardSubtitle,
          style:
              AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTypography.labelLg.copyWith(
        color: AppColors.outline,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Text(
            initial,
            style: AppTypography.labelLg.copyWith(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

/// "Günün Oyunu" bento-large (student-dashboard.md §3.3, Sapma 1).
///
/// F2.2: atanan bulmacayı temsil eder; "Oyuna Başla" → doğrudan oturum başlatma
/// (`POST /games/{id}/sessions`). Crossword grid yerine kelime-çifti mini
/// görseli.
class _GameOfDayCard extends StatefulWidget {
  const _GameOfDayCard({
    required this.game,
    required this.onPlay,
  });

  final AssignedGameDto game;
  final VoidCallback onPlay;

  @override
  State<_GameOfDayCard> createState() => _GameOfDayCardState();
}

class _GameOfDayCardState extends State<_GameOfDayCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPlay,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.outlineVariant),
            boxShadow: AppShadows.level2,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                right: -32,
                bottom: -32,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (widget.game.teacherName.isNotEmpty)
                          Text(
                            l10n.studentDashboardGameSharedBy(
                                widget.game.teacherName),
                            style: AppTypography.labelSm
                                .copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        _AssignedChip(label: l10n.studentDashboardGameAssigned),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(widget.game.title, style: AppTypography.headlineLg),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      l10n.studentDashboardGameDesc(widget.game.wordCount),
                      style: AppTypography.bodyMd
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _WordPairPreview(),
                    const SizedBox(height: AppSpacing.md),
                    _PlayButton(label: l10n.studentDashboardPlayGame),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Öğretmenin Atadığı Oyun" chip — tertiary tonlu.
class _AssignedChip extends StatelessWidget {
  const _AssignedChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chat_bubble_outline,
              size: 14, color: AppColors.tertiary),
          const SizedBox(width: AppSpacing.base),
          Text(label,
              style:
                  AppTypography.labelSm.copyWith(color: AppColors.tertiary)),
        ],
      ),
    );
  }
}

/// Sapma 1: crossword grid yerine "İngilizce ↔ Türkçe" çift rozetleri.
class _WordPairPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const pairs = [
      ('apple', 'elma'),
      ('book', 'kitap'),
      ('water', 'su'),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          for (var i = 0; i < pairs.length; i++) ...[
            Row(
              children: [
                Expanded(child: _Pill(pairs[i].$1)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  child: Icon(Icons.compare_arrows,
                      size: 18, color: AppColors.primary),
                ),
                Expanded(child: _Pill(pairs[i].$2)),
              ],
            ),
            if (i != pairs.length - 1)
              const SizedBox(height: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelLg.copyWith(color: AppColors.primary),
      ),
    );
  }
}

/// 3D primary buton (DESIGN.md) — kart içinde "Oyuna Başla". Tıklama kart
/// GestureDetector'ı tarafından yakalanır; bu yalnız görseldir.
class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: const [
          BoxShadow(color: AppColors.primaryShadow, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: AppTypography.labelLg.copyWith(color: AppColors.onPrimary)),
          const SizedBox(width: AppSpacing.xs),
          const Icon(Icons.play_arrow, color: AppColors.onPrimary, size: 20),
        ],
      ),
    );
  }
}

/// "Atanan Bulmacalar" listesindeki bulmaca satırı (bento-large dışındakiler).
/// Dokununca doğrudan oturum başlatılır (`POST /games/{id}/sessions`).
class _AssignedGameRow extends StatelessWidget {
  const _AssignedGameRow({
    required this.game,
    required this.onTap,
  });

  final AssignedGameDto game;
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
            border: Border.all(color: AppColors.outlineVariant),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.extension, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: AppTypography.headlineMd,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      l10n.studentDashboardPuzzleLesson(
                          game.lessonTitle, game.wordCount),
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

/// Boş durumda birincil "Bir Öğretmene Katıl" bento kartı (Sapma 4).
class _JoinTeacherCard extends StatelessWidget {
  const _JoinTeacherCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.primaryContainer,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppShadows.level2,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.group_add, color: AppColors.onPrimary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.studentDashboardJoinTeacherTitle,
                      style: AppTypography.headlineMd
                          .copyWith(color: AppColors.onPrimary),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      l10n.studentDashboardJoinTeacherDesc,
                      style: AppTypography.bodyMd.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.chevron_right, color: AppColors.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dolu durumda küçük tonal satır-link "Yeni öğretmene katıl".
class _JoinTeacherLink extends StatelessWidget {
  const _JoinTeacherLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add, color: AppColors.primary, size: 20),
        label: Text(
          l10n.studentDashboardJoinTeacherLinkShort,
          style: AppTypography.labelLg.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}

/// Gelişim Özeti — `GET /students/me/stats` gerçek verisinden: oynanan oyun
/// sayısı + ortalama doğruluk mini kartları + "Raporlarım" kısayolu.
/// Veri yoksa (hiç oyun oynanmadı) "Henüz oyun oynamadın" + Oyna CTA.
/// Yükleniyor/hata durumları ele alınır.
class _ProgressSummarySection extends ConsumerWidget {
  const _ProgressSummarySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statsAsync = ref.watch(studentStatsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionLabel(l10n.studentDashboardProgressTitle),
            InkWell(
              onTap: () => context.push(AppRoutes.studentResults),
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs, vertical: AppSpacing.base),
                child: Row(
                  children: [
                    Text(
                      l10n.studentDashboardSeeReports,
                      style: AppTypography.labelLg
                          .copyWith(color: AppColors.primary),
                    ),
                    const Icon(Icons.chevron_right,
                        color: AppColors.primary, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        statsAsync.when(
          loading: () => const SkeletonCard(height: 96),
          error: (_, __) => _ProgressNotice(
            icon: Icons.cloud_off,
            text: l10n.studentDashboardStatsError,
          ),
          data: (stats) {
            if (stats.gamesPlayed <= 0) {
              return const _ProgressEmpty();
            }
            return Row(
              children: [
                Expanded(
                  child: _ProgressStatCard(
                    icon: Icons.extension,
                    iconColor: AppColors.primary,
                    iconBg: AppColors.primaryFixed,
                    value: '${stats.gamesPlayed}',
                    label: l10n.studentDashboardStatGames,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _ProgressStatCard(
                    icon: Icons.verified,
                    iconColor: AppColors.tertiary,
                    iconBg: AppColors.tertiaryFixed,
                    value: l10n
                        .studentDashboardStatAccuracyValue(stats.accuracyPercent),
                    label: l10n.studentDashboardStatAccuracy,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Gelişim özeti mini metrik kartı (oyun sayısı / doğruluk).
class _ProgressStatCard extends StatelessWidget {
  const _ProgressStatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBg.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: AppTypography.headlineMd
                        .copyWith(color: AppColors.onSurface)),
                Text(
                  label,
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Boş — henüz oyun oynanmadı: açıklama satırı (üstte atanan bulmacalardan
/// oynanır; ayrıca "Raporlarım" kısayolu başlıkta mevcuttur).
class _ProgressEmpty extends StatelessWidget {
  const _ProgressEmpty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _ProgressNotice(
      icon: Icons.insights,
      text: l10n.studentDashboardStatsEmpty,
    );
  }
}

/// Hata/uyarı satırı (gelişim özeti).
class _ProgressNotice extends StatelessWidget {
  const _ProgressNotice({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

/// Boş/hata durumları için ortak kart.
class _StateCard extends StatelessWidget {
  const _StateCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.desc,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? desc;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
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
          Icon(icon, color: iconColor, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(title,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          if (desc != null) ...[
            const SizedBox(height: AppSpacing.base),
            Text(
              desc!,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: AppSpacing.md),
            action!,
          ],
        ],
      ),
    );
  }
}
