import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Oyun tamamlanma overlay'i — glass panel, card-pop giriş animasyonu.
///
/// M5: oyun bitince sonuç gönderimi sırasında **yükleniyor** (kutlama + spinner),
/// hata olursa **tekrar dene** gösterir; başarıda ekran rapor ekranına geçer
/// (overlay görünmez kalır). XP/skor burada gösterilmez (rapor ekranına ait).
class CompletionOverlay extends StatefulWidget {
  /// Yükleniyor: kutlama + mesaj + spinner (buton yok).
  const CompletionOverlay.submitting({
    super.key,
    required this.title,
    required this.message,
  }) : isError = false,
       actionLabel = null,
       onAction = null;

  /// Hata: kutlama yerine hata ikonu + mesaj + "Tekrar Dene".
  const CompletionOverlay.error({
    super.key,
    required this.title,
    required this.message,
    required String retryLabel,
    required VoidCallback onRetry,
  }) : isError = true,
       actionLabel = retryLabel,
       onAction = onRetry;

  final String title;
  final String message;
  final bool isError;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  State<CompletionOverlay> createState() => _CompletionOverlayState();
}

class _CompletionOverlayState extends State<CompletionOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  )..forward();

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.05), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 1.05, end: 1), weight: 50),
  ]).animate(CurvedAnimation(parent: _pop, curve: Curves.easeOut));

  @override
  void dispose() {
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.isError ? AppColors.error : AppColors.tertiary;
    return Positioned.fill(
      child: Semantics(
        container: true,
        child: ColoredBox(
          color: AppColors.onSurface.withValues(alpha: 0.4),
          child: Center(
            child: ScaleTransition(
              scale: _scale,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 5 / 6,
                    constraints: const BoxConstraints(maxWidth: 360),
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.2),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.isError
                                  ? Icons.cloud_off
                                  : Icons.celebration,
                              size: 48,
                              color: AppColors.onPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: AppTypography.displayLgMobile,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            widget.message,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          if (widget.isError)
                            OutlinedButton(
                              onPressed: widget.onAction,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(52),
                                side: const BorderSide(
                                  color: AppColors.outlineVariant,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.lg,
                                  ),
                                ),
                              ),
                              child: Text(widget.actionLabel!),
                            )
                          else
                            const SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
