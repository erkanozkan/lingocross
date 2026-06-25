import {
  Award,
  BookOpen,
  GraduationCap,
  Crown,
  ListChecks,
  PlayCircle,
  Puzzle,
  Type,
  Users,
  UserCheck,
  Gift,
} from "lucide-react";
import { StatCard } from "@/components/dashboard/StatCard";
import { useOverview } from "@/hooks/queries";
import { formatNumber, formatScore } from "@/lib/utils";

export function OverviewTab() {
  const { data, isLoading } = useOverview();
  const s = data?.subscriptions;

  return (
    <div className="space-y-6">
      <section className="space-y-3">
        <h3 className="text-sm font-semibold text-muted-foreground">Kullanıcılar</h3>
        <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
          <StatCard
            title="Toplam Kullanıcı"
            value={formatNumber(data?.totalUsers)}
            icon={Users}
            loading={isLoading}
          />
          <StatCard
            title="Öğretmen"
            value={formatNumber(data?.teacherCount)}
            icon={GraduationCap}
            loading={isLoading}
          />
          <StatCard
            title="Öğrenci"
            value={formatNumber(data?.studentCount)}
            icon={UserCheck}
            loading={isLoading}
          />
          <StatCard
            title="Aktif Öğrenci"
            value={formatNumber(data?.activeStudents7d)}
            hint={`Son 30 gün: ${formatNumber(data?.activeStudents30d)}`}
            icon={Users}
            loading={isLoading}
          />
        </div>
      </section>

      <section className="space-y-3">
        <h3 className="text-sm font-semibold text-muted-foreground">Abonelik</h3>
        <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
          <StatCard
            title="Premium (Aktif)"
            value={formatNumber(s?.premiumActive)}
            icon={Crown}
            loading={isLoading}
          />
          <StatCard
            title="Deneme"
            value={formatNumber(s?.trial)}
            icon={Gift}
            loading={isLoading}
          />
          <StatCard
            title="Ücretsiz"
            value={formatNumber(s?.free)}
            icon={Users}
            loading={isLoading}
          />
          <StatCard
            title="Ortalama Skor"
            value={formatScore(data?.averageScore)}
            icon={Award}
            loading={isLoading}
          />
        </div>
      </section>

      <section className="space-y-3">
        <h3 className="text-sm font-semibold text-muted-foreground">İçerik & Etkinlik</h3>
        <div className="grid grid-cols-2 gap-4 md:grid-cols-3 lg:grid-cols-6">
          <StatCard
            title="Aktif Sınıf"
            value={formatNumber(data?.activeClasses)}
            icon={BookOpen}
            loading={isLoading}
          />
          <StatCard
            title="Ders"
            value={formatNumber(data?.lessons)}
            icon={ListChecks}
            loading={isLoading}
          />
          <StatCard
            title="Kelime"
            value={formatNumber(data?.words)}
            icon={Type}
            loading={isLoading}
          />
          <StatCard
            title="Bulmaca/Oyun"
            value={formatNumber(data?.publishedGames)}
            icon={Puzzle}
            loading={isLoading}
          />
          <StatCard
            title="Oturum"
            value={formatNumber(data?.sessions)}
            icon={PlayCircle}
            loading={isLoading}
          />
          <StatCard
            title="Sonuç"
            value={formatNumber(data?.results)}
            icon={Award}
            loading={isLoading}
          />
        </div>
      </section>
    </div>
  );
}
