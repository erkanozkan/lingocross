import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../../auth/domain/auth_failure.dart';
import '../../../auth/presentation/auth_failure_messages.dart';
import '../../../auth/presentation/auth_notifier.dart';
import '../../../auth/presentation/auth_validators.dart';

/// Şifre Değiştir bottom-sheet (F4.2).
///
/// Mevcut + yeni + yeni-tekrar alanları → POST /auth/change-password
/// (AuthNotifier.changePassword). Dönen yeni token'lar saklanır, oturum korunur.
/// Yanlış mevcut şifre → "Mevcut şifre hatalı." (400).
class ChangePasswordSheet extends ConsumerStatefulWidget {
  const ChangePasswordSheet({super.key});

  /// Sheet'i açar; başarıda `true` döner.
  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => const ChangePasswordSheet(),
    );
  }

  @override
  ConsumerState<ChangePasswordSheet> createState() =>
      _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends ConsumerState<ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(authNotifierProvider.notifier).changePassword(
            currentPassword: _currentController.text,
            newPassword: _newController.text,
          );
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.accountChangePasswordSavedSnack)),
      );
      Navigator.of(context).pop(true);
    } on AuthFailure catch (failure) {
      if (!mounted) return;
      setState(() => _errorMessage = authFailureMessage(failure, l10n));
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = l10n.commonErrorGeneric);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.accountChangePasswordTitle,
                    style: AppTypography.headlineMd),
                const SizedBox(height: AppSpacing.lg),
                if (_errorMessage != null) ...[
                  ErrorBanner(message: _errorMessage!),
                  const SizedBox(height: AppSpacing.md),
                ],
                AppTextField(
                  label: l10n.accountChangePasswordCurrentLabel,
                  controller: _currentController,
                  hintText: l10n.authLoginPasswordPlaceholder,
                  leadingIcon: Icons.lock_outline,
                  obscureText: _obscureCurrent,
                  enabled: !_submitting,
                  textInputAction: TextInputAction.next,
                  validator: (v) => AuthValidators.loginPassword(v, l10n),
                  trailing: _ObscureToggle(
                    obscure: _obscureCurrent,
                    onTap: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: l10n.accountChangePasswordNewLabel,
                  controller: _newController,
                  hintText: l10n.authLoginPasswordPlaceholder,
                  leadingIcon: Icons.lock_reset,
                  obscureText: _obscureNew,
                  enabled: !_submitting,
                  textInputAction: TextInputAction.next,
                  validator: (v) => AuthValidators.newPassword(v, l10n),
                  trailing: _ObscureToggle(
                    obscure: _obscureNew,
                    onTap: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: l10n.accountChangePasswordConfirmLabel,
                  controller: _confirmController,
                  hintText: l10n.authLoginPasswordPlaceholder,
                  leadingIcon: Icons.lock_reset,
                  obscureText: _obscureConfirm,
                  enabled: !_submitting,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (v) {
                    if ((v ?? '').isEmpty) {
                      return l10n.authValidationPasswordRequired;
                    }
                    if (v != _newController.text) {
                      return l10n.accountChangePasswordMismatch;
                    }
                    return null;
                  },
                  trailing: _ObscureToggle(
                    obscure: _obscureConfirm,
                    onTap: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton3D(
                  label: _submitting
                      ? l10n.accountSavingLabel
                      : l10n.accountChangePasswordSubmit,
                  isLoading: _submitting,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed: _submitting
                      ? null
                      : () => Navigator.of(context).pop(false),
                  child: Text(
                    l10n.commonCancel,
                    style: AppTypography.labelLg
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ObscureToggle extends StatelessWidget {
  const _ObscureToggle({required this.obscure, required this.onTap});

  final bool obscure;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        obscure ? Icons.visibility_off : Icons.visibility,
        color: AppColors.outlineVariant,
      ),
    );
  }
}
