import { useState } from "react";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { TimeseriesChart } from "@/components/charts/TimeseriesChart";
import { CategoryBarChart } from "@/components/charts/CategoryBarChart";
import { DonutChart } from "@/components/charts/DonutChart";
import { RangeSelector } from "@/components/dashboard/RangeSelector";
import { QueryState } from "@/components/dashboard/QueryState";
import { useSubscriptions } from "@/hooks/queries";

const STATUS_LABELS: Record<string, string> = {
  premiumActive: "Premium (Aktif)",
  trial: "Deneme",
  canceled: "İptal",
  expired: "Süresi Dolmuş",
  free: "Ücretsiz",
};

export function SubscriptionsTab() {
  const [days, setDays] = useState(30);
  const subs = useSubscriptions(days);

  const breakdown = subs.data?.statusBreakdown;
  const statusData = breakdown
    ? Object.entries(breakdown).map(([key, value]) => ({
        name: STATUS_LABELS[key] ?? key,
        value: value as number,
      }))
    : [];

  const sourceData =
    subs.data?.bySource.map((s) => ({ name: s.type, value: s.sessions })) ?? [];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-end">
        <RangeSelector value={days} onChange={setDays} />
      </div>

      <div className="grid gap-4 lg:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Abonelik Durumu</CardTitle>
            <CardDescription>Duruma göre dağılım</CardDescription>
          </CardHeader>
          <CardContent>
            <QueryState isLoading={subs.isLoading} isError={subs.isError}>
              <DonutChart data={statusData} />
            </QueryState>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Kaynağa Göre</CardTitle>
            <CardDescription>Abonelik kaynağı dağılımı</CardDescription>
          </CardHeader>
          <CardContent>
            <QueryState isLoading={subs.isLoading} isError={subs.isError}>
              <CategoryBarChart data={sourceData} />
            </QueryState>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Yeni Abonelikler</CardTitle>
          <CardDescription>Günlük yeni abonelik (son {days} gün)</CardDescription>
        </CardHeader>
        <CardContent>
          <QueryState isLoading={subs.isLoading} isError={subs.isError}>
            <TimeseriesChart
              points={subs.data?.newSubscriptions.points ?? []}
              color="hsl(var(--chart-3))"
            />
          </QueryState>
        </CardContent>
      </Card>
    </div>
  );
}
