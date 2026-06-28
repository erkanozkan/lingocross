import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Şifre Sıfırlama ekranı — Şifremi Unuttum akışının ikinci adımı.
///
/// Kullanıcı e-postasına gelen 6 haneli kodu + yeni şifresini girer
/// (POST /api/auth/reset-password). Başarıda login'e döner; 400 → kod
/// hatalı/süresi dolmuş (backend mesajı gösterilir). Forgot ekranıyla görsel
/// tutarlı (kalkan ikonu, headline-lg, 3D buton). "Tekrar gönder" 30sn
/// cooldown'lı (forgot ekranındaki Timer deseni).
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});

  /// Forgot ekranından `extra` ile taşınan e-posta (açıklama + istek gövdesi).
  final String email;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _errorMessage;

  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;
  static const int _cooldownDuration = 30;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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
      await ref.read(authRepositoryProvider).resetPassword(
            email: widget.email,
            code: _codeController.text.trim(),
            newPassword: _passwordController.text,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(l10n.authResetSuccess)));
      context.go(AppRoutes.login);
    } on AuthFailure catch (failure) {
      if (!mounted) return;
      setState(() => _errorMessage = authFailureMessage(failure, l10n));
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = l10n.commonErrorGeneric);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// "Tekrar gönder" — forgot-password ucunu yeniden tetikler (cooldown'lı).
  Future<void> _resend() async {
    if (_cooldownSeconds > 0 || _loading) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _errorMessage = null);
    try {
      await ref
          .read(authRepositoryProvider)
          .forgotPassword(email: widget.email);
      if (!mounted) return;
      _startCooldown();
    } on AuthFailure catch (failure) {
      if (!mounted) return;
      setState(() => _errorMessage = authFailureMessage(failure, l10n));
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = l10n.authForgotErrorNetwork);
    }
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
                child: _buildForm(l10n),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    final resendLabel = _cooldownSeconds > 0
        ? '${l10n.authResetResend} ($_cooldownSeconds)'
        : l10n.authResetResend;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Forgot ekranıyla aynı görsel dil: kalkan ikonu hero.
          ExcludeSemantics(
            child: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.primaryFixed,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_reset,
                  color: AppColors.primary, size: 44),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.authResetTitle, style: AppTypography.headlineLg),
          const SizedBox(height: AppSpacing.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              l10n.authResetDescription(widget.email),
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
          // 6 haneli kod — ortalı, büyük, sadece rakam.
          AppTextField(
            label: l10n.authResetCodeLabel,
            controller: _codeController,
            hintText: l10n.authResetCodeHint,
            leadingIcon: Icons.pin_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            enabled: !_loading,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            textAlign: TextAlign.center,
            style: AppTypography.headlineMd.copyWith(letterSpacing: 8),
            validator: (v) => AuthValidators.resetCode(v, l10n),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l10n.authResetNewPasswordLabel,
            controller: _passwordController,
            hintText: l10n.authResetNewPasswordHint,
            leadingIcon: Icons.lock_outline,
            obscureText: _obscure,
            textInputAction: TextInputAction.next,
            enabled: !_loading,
            validator: (v) => AuthValidators.newPassword(v, l10n),
            trailing: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: AppColors.outlineVariant,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l10n.authResetConfirmPasswordLabel,
            controller: _confirmController,
            hintText: l10n.authResetConfirmPasswordHint,
            leadingIcon: Icons.lock_outline,
            obscureText: _obscure,
            textInputAction: TextInputAction.done,
            enabled: !_loading,
            onFieldSubmitted: (_) => _submit(),
            validator: (v) => AuthValidators.confirmPassword(
                v, _passwordController.text, l10n),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton3D(
            label: l10n.authResetSubmit,
            trailingIcon: Icons.check,
            isLoading: _loading,
            onPressed: _submit,
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
        ],
      ),
    );
  }
}
