import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../data/login_prefs.dart';
import '../../domain/auth_failure.dart';
import '../auth_failure_messages.dart';
import '../auth_notifier.dart';
import '../auth_validators.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_hero.dart';

/// Birleşik kimlik-doğrulama girişi (Karşılama + Giriş tek ekran).
///
/// Eski Welcome (hero: maskot + Hi!/Merhaba! rozetleri + başlık/alt yazı) ile
/// Giriş formu burada birleşti; uygulamanın tek auth giriş ekranıdır. Rol burada
/// belirlenmez — login yanıtındaki `user.role`'dan gelir ve yönlendirmeyi router
/// guard yapar. Sosyal giriş (OAuth) ve rol kartları gösterilmez.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  bool _rememberMe = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Açılışta "Beni Hatırla" tercihini ve kayıtlı e-postayı doldur.
    final prefs = ref.read(loginPrefsProvider);
    _rememberMe = prefs.rememberMe;
    if (_rememberMe) _emailController.text = prefs.savedEmail;
  }

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
    final email = _emailController.text.trim();
    try {
      await ref.read(authNotifierProvider.notifier).login(
            email: email,
            password: _passwordController.text,
          );
      // "Beni Hatırla" tercihini ve (açıksa) e-postayı kaydet — ŞİFRE DEĞİL.
      await ref
          .read(loginPrefsProvider)
          .save(remember: _rememberMe, email: email);
      // Sistem şifre kasasının autofill önerisini sunması için bağlamı kapat.
      TextInput.finishAutofillContext();
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
        // Üst marka: yalnız "LingoCross" wordmark (sağ-üstte redundant giriş
        // linki YOK — bu ekranın kendisi giriş ekranı).
        title: Text(l10n.appName,
            style: AppTypography.displayLgMobile
                .copyWith(color: AppColors.primary)),
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
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
                    const AuthHero(),
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
        child: AutofillGroup(
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
            const SizedBox(height: AppSpacing.xs),
            _RememberMe(
              value: _rememberMe,
              enabled: !_loading,
              onChanged: (v) => setState(() => _rememberMe = v),
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
      ),
    );
  }
}

/// "Beni Hatırla" checkbox satırı — Lumina Learning (primary tik, ≥48px hedef).
///
/// Stitch login ekranında YOKTUR; kullanıcı isteğiyle eklendi (bkz. DESIGN.md
/// sapma notu). Yalnız e-posta + tercih saklanır; şifre asla saklanmaz.
class _RememberMe extends StatelessWidget {
  const _RememberMe({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: enabled ? () => onChanged(!value) : null,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: enabled ? (v) => onChanged(v ?? false) : null,
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              l10n.authLoginRememberMe,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
