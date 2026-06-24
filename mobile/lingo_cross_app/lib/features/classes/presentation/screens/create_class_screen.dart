import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../domain/classes_failure.dart';
import '../classes_notifier.dart';
import '../create_class_controller.dart';

/// Yeni Sınıf (Stitch `84db4322…` birebir). Hero dekoratif kutu + "Sınıf Adı"
/// input + info metni + iki statik bilgi kartı (İlerleme Takibi / Ödül Sistemi)
/// + "Oluştur" 3D buton. Başarıda listeyi yeniler ve detay ekranını açar.
class CreateClassScreen extends ConsumerStatefulWidget {
  const CreateClassScreen({super.key});

  @override
  ConsumerState<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends ConsumerState<CreateClassScreen> {
  final _controller = TextEditingController();

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

  String get _name => _controller.text.trim();
  bool get _canSubmit => _name.isNotEmpty;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context);
    final created = await ref
        .read(createClassControllerProvider.notifier)
        .create(_name);
    if (!mounted) return;

    final l10n = AppLocalizations.of(context);
    if (created != null) {
      await ref.read(classesNotifierProvider.notifier).refresh();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.classCreateSuccess(created.name))),
      );
      // Listeye dön, ardından yeni sınıfın detayını aç.
      context.pop();
      context.push(AppRoutes.classDetail(created.id));
    } else {
      final error = ref.read(createClassControllerProvider).error;
      messenger.showSnackBar(
        SnackBar(content: Text(_errorMessage(error, l10n))),
      );
    }
  }

  String _errorMessage(Object? error, AppLocalizations l10n) {
    if (error is ClassesFailure) {
      return error.maybeWhen(
        network: () => l10n.classCreateErrorNetwork,
        orElse: () => l10n.classCreateErrorGeneric,
      );
    }
    return l10n.classCreateErrorGeneric;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final busy = ref.watch(createClassControllerProvider).isLoading;

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
          l10n.classCreateTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      // bottomNavigationBar klavyenin üstüne çıkmaz; submit'i body Column'una al.
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                AppSpacing.lg,
                AppSpacing.marginMobile,
                AppSpacing.xl,
              ),
              children: [
                const _HeroIllustration(),
                const SizedBox(height: AppSpacing.xl),
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.base),
                  child: Text(
                    l10n.classCreateNameLabel,
                    style: AppTypography.labelLg,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                _NameField(
                  controller: _controller,
                  enabled: !busy,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: AppSpacing.xs),
                _InfoLine(text: l10n.classCreateInfo),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _PerkCard(
                        icon: Icons.analytics,
                        iconColor: AppColors.primary,
                        label: l10n.classCreatePerkProgress,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _PerkCard(
                        icon: Icons.military_tech,
                        iconColor: AppColors.secondary,
                        label: l10n.classCreatePerkRewards,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              border: Border(top: BorderSide(color: AppColors.outlineVariant)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: PrimaryButton3D(
                  label: l10n.classCreateSubmit,
                  trailingIcon: Icons.auto_awesome,
                  isLoading: busy,
                  enabled: _canSubmit,
                  onPressed: _canSubmit ? _submit : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stitch hero görseli yerine basit dekoratif kutu (mevcut placeholder deseni).
class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryContainer, AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.level2,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -8,
              top: -8,
              child: Icon(
                Icons.auto_stories,
                size: 96,
                color: AppColors.onPrimary.withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              left: -8,
              bottom: -8,
              child: Icon(
                Icons.lightbulb,
                size: 80,
                color: AppColors.secondaryContainer.withValues(alpha: 0.5),
              ),
            ),
            const Icon(Icons.groups, size: 56, color: AppColors.onPrimary),
          ],
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.enabled,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      enabled: enabled,
      autofocus: true,
      textInputAction: TextInputAction.done,
      onSubmitted: onSubmitted,
      style: AppTypography.bodyMd,
      decoration: InputDecoration(
        hintText: l10n.classCreateNamePlaceholder,
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        suffixIcon: const Icon(Icons.group_add, color: AppColors.primary),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.outlineVariant,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.outlineVariant,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: AppTypography.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PerkCard extends StatelessWidget {
  const _PerkCard({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTypography.labelLg),
        ],
      ),
    );
  }
}
