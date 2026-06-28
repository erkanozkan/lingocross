import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Üstte görünür label + Lumina Learning input (docs/DESIGN.md + UX spec'ler).
///
/// Focus'ta leading ikon `outline-variant` → `primary` döner; hata durumunda
/// `error` rengine geçer. Tema [InputDecorationTheme] ile kenarlık/ring sağlar.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.leadingIcon,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.autofillHints,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.trailing,
    this.trailingLink,
    this.maxLines = 1,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.style,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? leadingIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  /// Input'un içinde sağda gösterilen widget (örn. şifre göster/gizle butonu).
  final Widget? trailing;

  /// Label satırının sağında gösterilen widget (örn. "Şifremi Unuttum?" link).
  final Widget? trailingLink;

  /// Çok satırlı giriş için satır sayısı (varsayılan 1).
  final int maxLines;

  /// Giriş biçimlendiriciler (örn. yalnız rakam, uzunluk sınırı).
  final List<TextInputFormatter>? inputFormatters;

  /// Metin hizalaması (örn. kod alanında ortalı).
  final TextAlign textAlign;

  /// Metin stili (varsayılan `bodyMd`; örn. kod alanında büyük + harf aralıklı).
  final TextStyle? style;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color get _iconColor {
    if (_hasError) return AppColors.error;
    if (_focused) return AppColors.primary;
    return AppColors.outlineVariant;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.base),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: AppTypography.labelLg
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
              if (widget.trailingLink != null) widget.trailingLink!,
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          obscureText: widget.obscureText,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          keyboardType: widget.keyboardType,
          autofillHints: widget.autofillHints,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          inputFormatters: widget.inputFormatters,
          textAlign: widget.textAlign,
          style: widget.style ?? AppTypography.bodyMd,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator == null
              ? null
              : (value) {
                  final error = widget.validator!(value);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _hasError != (error != null)) {
                      setState(() => _hasError = error != null);
                    }
                  });
                  return error;
                },
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.leadingIcon == null
                ? null
                : Icon(widget.leadingIcon, color: _iconColor),
            suffixIcon: widget.trailing,
          ),
        ),
      ],
    );
  }
}
