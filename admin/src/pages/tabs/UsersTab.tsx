import { useState } from "react";
import { Users } from "lucide-react";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { TimeseriesChart } from "@/components/charts/TimeseriesChart";
import { StatCard } from "@/components/dashboard/StatCard";
import { RangeSelector } from "@/components/dashboard/RangeSelector";
import { QueryState } from "@/components/dashboard/QueryState";
import { useOverview, useTimeseries } from "@/hooks/queries";
import { formatNumber } from "@/lib/utils";

export function UsersTab() {
  const [days, setDays] = useState(30);
  const ts = useTimeseries("signups", days);
  const { data: overview, isLoading } = useOverview();

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
        <StatCard
          title="Aktif Öğrenci (7g)"
          value={formatNumber(overview?.activeStudents7d)}
          icon={Users}
          loading={isLoading}
        />
        <StatCard
          title="Aktif Öğrenci (30g)"
          value={formatNumber(overview?.activeStudents30d)}
          icon={Users}
          loading={isLoading}
        />
        <StatCard
          title="Toplam Öğretmen"
          value={formatNumber(overview?.teacherCount)}
          loading={isLoading}
        />
        <StatCard
          title="Toplam Öğrenci"
          value={formatNumber(overview?.studentCount)}
          loading={isLoading}
        />
      </div>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0">
          <div>
            <CardTitle>Yeni Kayıtlar</CardTitle>
            <CardDescription>Günlük kayıt sayısı (son {days} gün)</CardDescription>
          </div>
          <RangeSelector value={days} onChange={setDays} />
        </CardHeader>
        <CardContent>
          <QueryState isLoading={ts.isLoading} isError={ts.isError}>
            <TimeseriesChart points={ts.data?.points ?? []} />
          </QueryState>
        </CardContent>
      </Card>
    </div>
  );
}
