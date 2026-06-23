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
import '../../domain/auth_failure.dart';
import '../../domain/user_role.dart';
import '../auth_failure_messages.dart';
import '../auth_notifier.dart';
import '../auth_validators.dart';
import '../widgets/role_select_card.dart';

/// Hesap Oluştur ekranı (UX: auth-register.md). Rol burada belirlenir;
/// `?role=student|teacher` query param ile gelen rolü ön-seçer (param yoksa
/// varsayılan öğrenci). Başarıda API token döner → otomatik login → /home
/// (router guard). Sosyal kayıt M1'de gösterilmez.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, this.initialRole = UserRole.student});

  /// Welcome'dan gelen ön-seçili rol (varsayılan öğrenci).
  final UserRole initialRole;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late UserRole _role = widget.initialRole;
  bool _termsAccepted = false;
  bool _termsError = false;
  bool _obscure = true;
  bool _loading = false;
  String? _errorMessage;
  String? _emailFieldError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _errorMessage = null;
      _emailFieldError = null;
      _termsError = !_termsAccepted;
    });

    final formValid = _formKey.currentState!.validate();
    if (!formValid || !_termsAccepted) return;

    setState(() => _loading = true);
    try {
      await ref.read(authNotifierProvider.notifier).register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _fullNameController.text.trim(),
            role: _role,
          );
      // Başarıda router guard otomatik /home'a yönlendirir (auto-login).
    } on AuthFailure catch (failure) {
      if (!mounted) return;
      setState(() {
        if (failure is EmailTaken) {
          _emailFieldError = l10n.authRegisterErrorEmailTaken;
          _formKey.currentState!.validate();
        } else {
          _errorMessage = authFailureMessage(failure, l10n);
        }
      });
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
            onPressed: () => context.go(AppRoutes.login),
            child: Text(
              l10n.authRegisterAppbarLogin,
              style:
                  AppTypography.labelLg.copyWith(color: AppColors.primary),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l10n.authRegisterTitle,
                          textAlign: TextAlign.center,
                          style: AppTypography.displayLgMobile),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.authRegisterSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMd
                            .copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (_errorMessage != null) ...[
                        ErrorBanner(message: _errorMessage!),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      _buildRoleSelector(l10n),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        label: l10n.authRegisterFullNameLabel,
                        controller: _fullNameController,
                        hintText: l10n.authRegisterFullNamePlaceholder,
                        keyboardType: TextInputType.name,
                        autofillHints: const [AutofillHints.name],
                        textInputAction: TextInputAction.next,
                        enabled: !_loading,
                        validator: (v) => AuthValidators.fullName(v, l10n),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: l10n.authRegisterEmailLabel,
                        controller: _emailController,
                        hintText: l10n.authRegisterEmailPlaceholder,
                        leadingIcon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.next,
                        enabled: !_loading,
                        validator: (v) {
                          if (_emailFieldError != null) return _emailFieldError;
                          return AuthValidators.email(v, l10n);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: l10n.authRegisterPasswordLabel,
                        controller: _passwordController,
                        hintText: l10n.authRegisterPasswordPlaceholder,
                        leadingIcon: Icons.lock_outline,
                        obscureText: _obscure,
                        autofillHints: const [AutofillHints.newPassword],
                        textInputAction: TextInputAction.done,
                        enabled: !_loading,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (v) => AuthValidators.newPassword(v, l10n),
                        trailing: IconButton(
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.outlineVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _buildTermsCheckbox(l10n),
                      const SizedBox(height: AppSpacing.lg),
                      PrimaryButton3D(
                        label: l10n.authRegisterSubmit,
                        isLoading: _loading,
                        enabled: _termsAccepted,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _buildLoginLink(l10n),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector(AppLocalizations l10n) {
    return Semantics(
      label: l10n.authRegisterRoleGroupLabel,
      container: true,
      child: Row(
        children: [
          Expanded(
            child: RoleSelectCard(
              icon: Icons.school,
              iconColor: AppColors.primary,
              label: l10n.authRegisterRoleStudent,
              selected: _role == UserRole.student,
              onTap: () => setState(() => _role = UserRole.student),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: RoleSelectCard(
              icon: Icons.co_present,
              iconColor: AppColors.tertiary,
              label: l10n.authRegisterRoleTeacher,
              selected: _role == UserRole.teacher,
              onTap: () => setState(() => _role = UserRole.teacher),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox(AppLocalizations l10n) {
    final base =
        AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant);
    final link = base.copyWith(color: AppColors.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _termsAccepted,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() {
                  _termsAccepted = v ?? false;
                  if (_termsAccepted) _termsError = false;
                }),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _termsAccepted = !_termsAccepted;
                  if (_termsAccepted) _termsError = false;
                }),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${l10n.authRegisterTermsPrefix} '),
                      TextSpan(text: l10n.authRegisterTermsTerms, style: link),
                      TextSpan(text: ' ${l10n.authRegisterTermsAnd} '),
                      TextSpan(
                          text: l10n.authRegisterTermsPrivacy, style: link),
                    ],
                  ),
                  style: base,
                ),
              ),
            ),
          ],
        ),
        if (_termsError)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.base),
            child: Text(
              l10n.authValidationTermsRequired,
              style: AppTypography.labelSm.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }

  Widget _buildLoginLink(AppLocalizations l10n) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          '${l10n.authRegisterHaveAccount} ',
          style: AppTypography.bodyMd
              .copyWith(color: AppColors.onSurfaceVariant),
        ),
        GestureDetector(
          onTap: () => context.go(AppRoutes.login),
          child: Text(
            l10n.authRegisterLoginCta,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
