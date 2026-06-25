import 'package:flutter/material.dart';

/// Bir ekran açıldığında (veya bir sekmeye geçildiğinde) **bir kez** veri
/// yenilemesini tetikleyen küçük yardımcı sarmalayıcı.
///
/// Amaç (DÜZELTME 3): liste/detay ekranları yalnız pull-to-refresh ile değil,
/// ekrana girişte de güncel veriyi çeker. Yenileme sırasında mevcut veri
/// gösterilmeye devam eder (provider'lar `state`'i korur), bu yüzden boş ekran
/// flaşı olmaz.
///
/// Kullanım: ekranın gövdesini bununla sarmalayıp [onMount] içinde ilgili
/// sağlayıcıları yenilersiniz (`ref.invalidate(...)` veya
/// `ref.read(p.notifier).refresh()`). `build` her yeniden çalıştığında değil,
/// yalnızca `initState`'te çağrılır → aşırı yenileme olmaz.
///
/// `ConsumerWidget` ekranları için: `build` içinde döndürülen ağacı bununla
/// sar ve `onMount` callback'inde `ref`'i kapanışla yakala. `ref` widget'ın
/// ömrü boyunca geçerlidir (ekran kalktığında zaten tetiklenmez).
class RefreshOnMount extends StatefulWidget {
  const RefreshOnMount({
    super.key,
    required this.onMount,
    required this.child,
  });

  /// Ekran ilk kez bağlandığında bir kez çağrılır (post-frame).
  final VoidCallback onMount;

  final Widget child;

  @override
  State<RefreshOnMount> createState() => _RefreshOnMountState();
}

class _RefreshOnMountState extends State<RefreshOnMount> {
  @override
  void initState() {
    super.initState();
    // İlk frame'den sonra tetikle ki provider'lar build sırasında değişmesin.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onMount();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
