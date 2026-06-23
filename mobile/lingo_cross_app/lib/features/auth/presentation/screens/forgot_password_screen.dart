import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_failure.dart';
import '../auth_failure_messages.dart';
import '../auth_validators.dart';

/// Şifremi Unuttum ekranı (UX: auth-forgot-password.md).
///
/// Güvenlik: kayıtlı olmayan e-posta sızdırılmaz → her geçerli e-posta aynı
/// başarı bloğunu gösterir. Başlık `headline-lg` (orchestrator: headline-lg-mobile
/// tanımsız). "Tekrar gönder" 30sn cooldown'lı.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _loading = false;
  bool _success = false;
  String? _errorMessage;

  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;
  static const int _cooldownDuration = 30;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _cooldownSeconds = _cooldownDuration);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _cooldownSeconds--);
      if (_cooldownSeconds <= 0) timer.cancel();
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).forgotPassword(
            email: _emailController.text.trim(),
          );
      if (!mounted) return;
      setState(() => _success = true);
      _startCooldown();
    } on AuthFailure catch (failure) {
      if (!mounted) return;
      // Yalnız ağ/sunucu hatası gösterilir (kayıtlı olmama gizlenir).
      setState(() => _errorMessage = authFailureMessage(failure, l10n));
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = l10n.authForgotErrorNetwork);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    if (_cooldownSeconds > 0) return;
    await _submit();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.login);
            }
          },
        ),
        title: Text(l10n.appName,
            style: AppTypography.displayLgMobile
                .copyWith(color: AppColors.primary)),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                  vertical: AppSpacing.lg,
                ),
                child: _success ? _buildSuccess(l10n) : _buildForm(l10n),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // İllüstrasyon yok → graceful fallback (kalkan ikonu).
          ExcludeSemantics(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield_outlined,
                  color: AppColors.primary, size: 44),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.authForgotTitle, style: AppTypography.headlineLg),
          const SizedBox(height: AppSpacing.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              l10n.authForgotDescription,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (_errorMessage != null) ...[
            ErrorBanner(message: _errorMessage!),
            const SizedBox(height: AppSpacing.md),
          ],
          AppTextField(
            label: l10n.authForgotEmailLabel,
            controller: _emailController,
            hintText: l10n.authForgotEmailPlaceholder,
            leadingIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.done,
            enabled: !_loading,
            onFieldSubmitted: (_) => _submit(),
            validator: (v) => AuthValidators.email(v, l10n),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton3D(
            label: l10n.authForgotSubmit,
            trailingIcon: Icons.send,
            isLoading: _loading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildSupport(l10n),
        ],
      ),
    );
  }

  Widget _buildSuccess(AppLocalizations l10n) {
    final resendLabel = _cooldownSeconds > 0
        ? '${l10n.authForgotSuccessResend} ($_cooldownSeconds)'
        : l10n.authForgotSuccessResend;

    return Semantics(
      liveRegion: true,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.tertiaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle,
                color: AppColors.onTertiaryFixed, size: 32),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.authForgotSuccessTitle, style: AppTypography.headlineMd),
          const SizedBox(height: AppSpacing.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              l10n.authForgotSuccessDescription,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed:
                (_loading || _cooldownSeconds > 0) ? null : _resend,
            child: Text(
              resendLabel,
              style: AppTypography.labelLg.copyWith(
                color: _cooldownSeconds > 0
                    ? AppColors.onSurfaceVariant
                    : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSupport(l10n),
        ],
      ),
    );
  }

  Widget _buildSupport(AppLocalizations l10n) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          '${l10n.authForgotSupportPrefix} ',
          style: AppTypography.labelSm
              .copyWith(color: AppColors.onSurfaceVariant),
        ),
        Text(
          l10n.authForgotSupportContact,
          style: AppTypography.labelSm.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
