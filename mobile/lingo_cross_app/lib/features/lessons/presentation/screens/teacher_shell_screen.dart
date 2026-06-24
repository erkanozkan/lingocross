import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../classes/presentation/screens/classes_list_screen.dart';
import '../widgets/teacher_bottom_nav.dart';
import 'teacher_dashboard_screen.dart';
import 'teacher_profile_screen.dart';
import 'teacher_reports_screen.dart';

/// Öğretmen kabuğu — 4 sekmeli alt nav (Stitch birebir):
/// **Ana Sayfa / Sınıflar / Raporlar / Profil**.
///
/// Sekme gövdeleri [IndexedStack] ile durum korunarak tutulur; her gövde kendi
/// Scaffold/AppBar'ına sahip, alt nav'ı kabuk sağlar. Profil menüsündeki
/// "Sınıf Yönetimi" / "İstatistikler" girişleri ilgili sekmeye geçer.
class TeacherShellScreen extends StatefulWidget {
  const TeacherShellScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<TeacherShellScreen> createState() => _TeacherShellScreenState();
}

class _TeacherShellScreenState extends State<TeacherShellScreen> {
  late int _index = widget.initialIndex;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(
        index: _index,
        children: [
          // "Öğrenci Gelişimi" kartı → Raporlar sekmesi (index 2);
          // üst bar avatarı → Profil sekmesi (index 3).
          // index 1 = "Sınıflarım" (F4.3 — eskiden yanlışlıkla Derslerim'di).
          TeacherDashboardScreen(
            onOpenReports: () => _go(2),
            onOpenProfile: () => _go(3),
          ),
          const ClassesListScreen(),
          const TeacherReportsScreen(),
          TeacherProfileScreen(
            onOpenClasses: () => _go(1),
            onOpenReports: () => _go(2),
          ),
        ],
      ),
      bottomNavigationBar: TeacherBottomNav(
        currentIndex: _index,
        onTap: _go,
      ),
    );
  }
}
