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
import '../../domain/enrollment_failure.dart';
import '../enrollments_notifier.dart';
import '../join_teacher_controller.dart';

/// Öğretmene Katıl (student-join-teacher.md). Davet kodu input + "Katıl" →
/// `POST /api/enrollments/join`. Katılım doğrudan Active (onay yok); başarıda
/// panele döner + snackbar. Hatalar: geçersiz kod (404), zaten katılmış (409
/// idempotent → başarı), süresi dolmuş (410), ağ.
class JoinTeacherScreen extends ConsumerStatefulWidget {
  const JoinTeacherScreen({super.key});

  @override
  ConsumerState<JoinTeacherScreen> createState() => _JoinTeacherScreenState();
}

class _JoinTeacherScreenState extends ConsumerState<JoinTeacherScreen> {
  final _controller = TextEditingController();

  /// Backend 8 haneli (harf+rakam, karışan karakterler hariç) davet kodu üretir.
  /// Tam uzunlukta buton aktifleşir.
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
    final enrollment =
        await ref.read(joinTeacherControllerProvider.notifier).submit(_code);
    if (!mounted) return;

    if (enrollment != null) {
      // Panel listesini yenile, snackbar, panele dön.
      await ref.read(enrollmentsNotifierProvider.notifier).refresh();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.tertiary,
          content: Text(
            l10n.studentJoinSuccess(enrollment.counterpartDisplayName),
            style: TextStyle(color: AppColors.onTertiary),
          ),
        ),
      );
      context.go(AppRoutes.student);
    }
    // Hata durumu state üzerinden ekranda gösterilir (yardımcı satır).
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(joinTeacherControllerProvider);
    final isLoading = state.isLoading;
    final failure =
        state.error is EnrollmentFailure ? state.error as EnrollmentFailure : null;
    // Herhangi bir hata input kenarlığını kırmızıya çeker (yardımcı satır metni
    // hata türüne göre değişir — bkz. _HelperLine).
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
          l10n.studentJoinAppBarTitle,
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
            // Hero
            Center(
              child: Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.group_add,
                    color: AppColors.primary, size: 36),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.studentJoinHeroTitle,
              textAlign: TextAlign.center,
              style: AppTypography.headlineLg,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.studentJoinHeroDesc,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Kod giriş alanı
            Text(
              l10n.studentJoinCodeLabel,
              style: AppTypography.labelLg
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xs),
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

            // Katıl
            PrimaryButton3D(
              label: isLoading
                  ? l10n.studentJoinSubmitting
                  : l10n.studentJoinSubmit,
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
    final borderColor = hasError ? AppColors.error : AppColors.outline;
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
        // Boşluk/tire temizle + otomatik büyük harf (kod görünümü).
        FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
        TextInputFormatter.withFunction(
          (oldValue, newValue) => newValue.copyWith(
            text: newValue.text.toUpperCase(),
            selection: newValue.selection,
          ),
        ),
      ],
      style: AppTypography.headlineMd.copyWith(letterSpacing: 6),
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(
            color: hasError ? AppColors.error : AppColors.primary,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}

/// Yardımcı satır: hata yoksa nötr ipucu; hata varsa tip-bazlı kırmızı/bilgi.
class _HelperLine extends StatelessWidget {
  const _HelperLine({required this.failure});

  final EnrollmentFailure? failure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final String text;
    final Color color;
    if (failure == null) {
      text = l10n.studentJoinCodeHint;
      color = AppColors.onSurfaceVariant;
    } else {
      color = AppColors.error;
      text = failure!.when(
        network: () => l10n.studentJoinErrorNetwork,
        invalidCode: () => l10n.studentJoinErrorInvalid,
        expiredCode: () => l10n.studentJoinErrorExpired,
        forbidden: () => l10n.studentJoinErrorInvalid,
        unexpected: () => l10n.commonErrorGeneric,
      );
    }
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.base),
        child: Text(
          text,
          style: AppTypography.labelSm.copyWith(color: color),
        ),
      ),
    );
  }
}
