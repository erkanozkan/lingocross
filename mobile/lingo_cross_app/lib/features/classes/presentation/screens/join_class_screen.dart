import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../../enrollment/presentation/enrollments_notifier.dart';
import '../../domain/classes_failure.dart';
import '../join_class_controller.dart';
import '../my_classes_notifier.dart';

/// Sınıfa Katıl (Stitch `58e4b1e0…` birebir, öğrenci). İkon + "Yeni Bir Sınıf"
/// + açıklama + 8-karakter kod input (otomatik büyük harf) + "Kod Nerede?"
/// bilgi kartı + "Katıl" 3D buton. Başarıda öğrenci panelini yeniler ve döner.
class JoinClassScreen extends ConsumerStatefulWidget {
  const JoinClassScreen({super.key});

  @override
  ConsumerState<JoinClassScreen> createState() => _JoinClassScreenState();
}

class _JoinClassScreenState extends ConsumerState<JoinClassScreen> {
  final _controller = TextEditingController();

  /// Backend 8 haneli (harf+rakam) davet kodu üretir.
  static const int _codeLength = 8;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _code => _controller.text.trim();
  bool get _canSubmit => _code.length >= _codeLength;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context);
    final membership =
        await ref.read(joinClassControllerProvider.notifier).submit(_code);
    if (!mounted) return;

    if (membership != null) {
      // Öğrenci panelini besleyen sağlayıcıları yenile.
      await ref.read(myClassesNotifierProvider.notifier).refresh();
      // Eski öğretmen-enrollment listesi de panelde kullanılıyor; varsa yenile.
      ref.invalidate(enrollmentsNotifierProvider);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.tertiary,
          content: Text(
            l10n.joinClassSuccess(membership.className),
            style: const TextStyle(color: AppColors.onTertiary),
          ),
        ),
      );
      context.go(AppRoutes.student);
    }
    // Hata state üzerinden yardımcı satırda gösterilir.
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(joinClassControllerProvider);
    final isLoading = state.isLoading;
    final failure =
        state.error is ClassesFailure ? state.error as ClassesFailure : null;
    final fieldHasError = failure != null;

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
          l10n.joinClassTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.xl,
            AppSpacing.marginMobile,
            AppSpacing.xl,
          ),
          children: [
            Center(
              child: Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.group_add,
                    color: AppColors.primary, size: 48),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.joinClassHeroTitle,
              textAlign: TextAlign.center,
              style: AppTypography.headlineLg,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.joinClassHeroDesc,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xl),
            _CodeField(
              controller: _controller,
              enabled: !isLoading,
              hasError: fieldHasError,
              maxLength: _codeLength,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.xs),
            _HelperLine(failure: failure),
            const SizedBox(height: AppSpacing.lg),
            const _WhereIsCodeCard(),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton3D(
              label: isLoading ? l10n.joinClassSubmitting : l10n.joinClassSubmit,
              trailingIcon: Icons.chevron_right,
              enabled: _canSubmit,
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeField extends StatelessWidget {
  const _CodeField({
    required this.controller,
    required this.enabled,
    required this.hasError,
    required this.maxLength,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool hasError;
  final int maxLength;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final borderColor = hasError ? AppColors.error : AppColors.outlineVariant;
    return TextField(
      controller: controller,
      enabled: enabled,
      autofocus: true,
      textAlign: TextAlign.center,
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.go,
      autofillHints: const [AutofillHints.oneTimeCode],
      maxLength: maxLength,
      onSubmitted: onSubmitted,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
        TextInputFormatter.withFunction(
          (oldValue, newValue) => newValue.copyWith(
            text: newValue.text.toUpperCase(),
            selection: newValue.selection,
          ),
        ),
      ],
      style: AppTypography.headlineLg.copyWith(letterSpacing: 6),
      decoration: InputDecoration(
        counterText: '',
        hintText: l10n.joinClassCodePlaceholder,
        hintStyle: AppTypography.headlineLg.copyWith(
          letterSpacing: 6,
          color: AppColors.outlineVariant,
        ),
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: hasError ? AppColors.error : AppColors.primary,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }
}

/// "Kod Nerede?" bilgi kartı (Stitch bento ipucu).
class _WhereIsCodeCard extends StatelessWidget {
  const _WhereIsCodeCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(Icons.info, color: AppColors.onPrimaryContainer),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.joinClassWhereTitle, style: AppTypography.labelLg),
                const SizedBox(height: AppSpacing.base),
                Text(
                  l10n.joinClassWhereDesc,
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Yardımcı satır: hata yoksa nötr ipucu; hata varsa tip-bazlı kırmızı.
class _HelperLine extends StatelessWidget {
  const _HelperLine({required this.failure});

  final ClassesFailure? failure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final String text;
    final Color color;
    if (failure == null) {
      text = l10n.joinClassCodeHint;
      color = AppColors.onSurfaceVariant;
    } else {
      color = AppColors.error;
      text = failure!.when(
        network: () => l10n.joinClassErrorNetwork,
        invalidCode: () => l10n.joinClassErrorInvalid,
        // Katılma bağlamında 404 = geçersiz/arşivli kod.
        notFound: () => l10n.joinClassErrorInvalid,
        forbidden: () => l10n.joinClassErrorInvalid,
        unexpected: () => l10n.commonErrorGeneric,
      );
    }
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.base),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTypography.labelSm.copyWith(color: color),
        ),
      ),
    );
  }
}
