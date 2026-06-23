import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../domain/auth_failure.dart';
import '../auth_failure_messages.dart';
import '../auth_notifier.dart';
import '../auth_validators.dart';
import '../widgets/auth_footer.dart';

/// Giriş Yap ekranı (UX: auth-login.md). Sosyal giriş M1'de gösterilmez.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.roleHint});

  /// Welcome'dan taşınan rol bağlamı (UI'yi değiştirmez; gerçek rol login
  /// yanıtından gelir).
  final String? roleHint;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await ref.read(authNotifierProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      // Başarıda router guard otomatik /home'a yönlendirir.
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName,
            style: AppTypography.displayLgMobile
                .copyWith(color: AppColors.primary)),
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              l10n.authLoginAppbarHelp,
              style: AppTypography.labelLg
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
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
                child: Column(
                  children: [
                    Text(l10n.authLoginTitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.displayLgMobile),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.authLoginSubtitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMd
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildCard(l10n),
                    const SizedBox(height: AppSpacing.lg),
                    const AuthFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (_errorMessage != null) ...[
              ErrorBanner(message: _errorMessage!),
              const SizedBox(height: AppSpacing.md),
            ],
            AppTextField(
              label: l10n.authLoginEmailLabel,
              controller: _emailController,
              hintText: l10n.authLoginEmailPlaceholder,
              leadingIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.username, AutofillHints.email],
              textInputAction: TextInputAction.next,
              enabled: !_loading,
              validator: (v) => AuthValidators.email(v, l10n),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: l10n.authLoginPasswordLabel,
              controller: _passwordController,
              hintText: l10n.authLoginPasswordPlaceholder,
              leadingIcon: Icons.lock_outline,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              enabled: !_loading,
              onFieldSubmitted: (_) => _submit(),
              validator: (v) => AuthValidators.loginPassword(v, l10n),
              trailingLink: GestureDetector(
                onTap: () => context.go(AppRoutes.forgotPassword),
                child: Text(
                  l10n.authLoginForgotPassword,
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.primary),
                ),
              ),
              trailing: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.outlineVariant,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton3D(
              label: l10n.authLoginSubmit,
              trailingIcon: Icons.arrow_forward,
              isLoading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: AppSpacing.xl),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  '${l10n.authLoginNoAccount} ',
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.register),
                  child: Text(
                    l10n.authLoginSignupCta,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
