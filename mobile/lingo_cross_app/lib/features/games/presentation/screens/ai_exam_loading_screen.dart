import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Yapay Zeka ile Sınav Soruları — yükleme ekranı (Stitch `exam_loading`
/// birebir): parıltılı çember + auto_awesome simgesi + "Sorular hazırlanıyor…"
/// + alt metin + pill ilerleme çubuğu (animasyonla ~%90'a yaklaşır, "ilerleme
/// hissi"). Üretim isteği bitince üst ekran (config) review'a geçer.
class AiExamLoadingScreen extends StatefulWidget {
  const AiExamLoadingScreen({super.key});

  @override
  State<AiExamLoadingScreen> createState() => _AiExamLoadingScreenState();
}

class _AiExamLoadingScreenState extends State<AiExamLoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulse;
  late final AnimationController _progress;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    // İlerleme animasyonu yavaşça ~%90'a yaklaşır (gerçek bitiş ekran geçişiyle).
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..forward();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.aiExamCreateTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Glow(pulse: _pulse),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.aiExamLoadingTitle,
                textAlign: TextAlign.center,
                style: AppTypography.headlineLg
                    .copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.aiExamLoadingSubtitle,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xl),
              AnimatedBuilder(
                animation: _progress,
                builder: (context, _) {
                  // 0 → ~0.9 eased; gerçek bitiş ekran geçişiyle olur.
                  final value = _progress.value * 0.9;
                  final percent = (value * 100).round();
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 10,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.aiExamLoadingProgress(percent),
                        style: AppTypography.labelSm
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Parıltılı çember (Stitch §glow): nabız atan halka + ortada auto_awesome.
class _Glow extends StatelessWidget {
  const _Glow({required this.pulse});

  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (context, _) {
        final t = pulse.value;
        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Dış nabız halkası.
              Container(
                width: 160 + 24 * t,
                height: 160 + 24 * t,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.outlineVariant
                        .withValues(alpha: 0.6 - 0.4 * t),
                  ),
                ),
              ),
              // İç beyaz daire + parıltı gölge.
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ambientShadow,
                      blurRadius: 24 + 8 * t,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.auto_awesome,
                  size: 44,
                  color: Color.lerp(
                    AppColors.primary,
                    AppColors.primaryContainer,
                    t,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
