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

/// Profil Düzenle bottom-sheet (F4.2) — görünen adı düzenler.
///
/// Kaydet → PUT /auth/me (AuthNotifier.updateProfile) → state tazelenir.
class EditProfileSheet extends ConsumerStatefulWidget {
  const EditProfileSheet({super.key, required this.initialName});

  final String initialName;

  /// Sheet'i açar; başarıda `true` döner.
  static Future<bool?> show(BuildContext context, {required String initialName}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => EditProfileSheet(initialName: initialName),
    );
  }

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController =
      TextEditingController(text: widget.initialName);

  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .updateProfile(displayName: _nameController.text.trim());
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.accountEditProfileSavedSnack)),
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
                Text(l10n.accountEditProfileTitle,
                    style: AppTypography.headlineMd),
                const SizedBox(height: AppSpacing.lg),
                if (_errorMessage != null) ...[
                  ErrorBanner(message: _errorMessage!),
                  const SizedBox(height: AppSpacing.md),
                ],
                AppTextField(
                  label: l10n.accountEditProfileNameLabel,
                  controller: _nameController,
                  hintText: l10n.accountEditProfileNamePlaceholder,
                  leadingIcon: Icons.person_outline,
                  enabled: !_submitting,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.authValidationFullNameRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton3D(
                  label: _submitting
                      ? l10n.accountSavingLabel
                      : l10n.accountSaveLabel,
                  isLoading: _submitting,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed:
                      _submitting ? null : () => Navigator.of(context).pop(false),
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
