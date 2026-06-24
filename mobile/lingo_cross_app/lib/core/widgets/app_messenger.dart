import 'package:flutter/material.dart';

/// Uygulama genelinde erişilebilen `ScaffoldMessenger` anahtarı.
///
/// Foreground push bildirimlerini (ekran bağlamı olmadan) SnackBar ile
/// göstermek için kullanılır. `MaterialApp.router`'a `scaffoldMessengerKey`
/// olarak verilir.
final GlobalKey<ScaffoldMessengerState> appMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
