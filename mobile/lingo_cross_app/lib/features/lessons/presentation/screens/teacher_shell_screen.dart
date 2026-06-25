import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../classes/presentation/classes_notifier.dart';
import '../../../classes/presentation/screens/classes_list_screen.dart';
import '../../../profile/presentation/teacher_stats_notifier.dart';
import '../../../tracking/presentation/students_notifier.dart';
import '../lessons_notifier.dart';
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
class TeacherShellScreen extends ConsumerStatefulWidget {
  const TeacherShellScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<TeacherShellScreen> createState() => _TeacherShellScreenState();
}

class _TeacherShellScreenState extends ConsumerState<TeacherShellScreen> {
  late int _index = widget.initialIndex;

  /// Sekme DEĞİŞİNCE (DÜZELTME 3) aktif sekmenin sağlayıcılarını yenile —
  /// böylece sekmeye dönünce bayat veri kalmaz. IndexedStack durumu koruduğu
  /// için invalidate ile yeniden çekilir; mevcut veri gösterilmeye devam eder.
  void _go(int i) {
    if (i == _index) return;
    setState(() => _index = i);
    _refreshTab(i);
  }

  void _refreshTab(int i) {
    switch (i) {
      case 0: // Ana Sayfa: dersler + öğrenciler özetleri
        ref.invalidate(lessonsNotifierProvider);
        ref.invalidate(studentsNotifierProvider);
      case 1: // Sınıflar
        ref.invalidate(classesNotifierProvider);
      case 2: // Raporlar
        ref.invalidate(studentsNotifierProvider);
      case 3: // Profil
        ref.invalidate(teacherStatsNotifierProvider);
    }
  }

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
