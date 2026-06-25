import { useState } from "react";
import { Award, Share2 } from "lucide-react";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { TimeseriesChart } from "@/components/charts/TimeseriesChart";
import { CategoryBarChart } from "@/components/charts/CategoryBarChart";
import { StatCard } from "@/components/dashboard/StatCard";
import { RangeSelector } from "@/components/dashboard/RangeSelector";
import { QueryState } from "@/components/dashboard/QueryState";
import { useEngagement, useTimeseries } from "@/hooks/queries";
import { formatNumber, formatPercent, formatScore } from "@/lib/utils";

export function EngagementTab() {
  const [days, setDays] = useState(30);
  const sessions = useTimeseries("sessions", days);
  const results = useTimeseries("results", days);
  const eng = useEngagement();

  const gameTypeData =
    eng.data?.gameTypes.map((g) => ({ name: g.type, value: g.sessions })) ?? [];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-end">
        <RangeSelector value={days} onChange={setDays} />
      </div>

      <div className="grid gap-4 lg:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Oturumlar</CardTitle>
            <CardDescription>Günlük oturum sayısı (son {days} gün)</CardDescription>
          </CardHeader>
          <CardContent>
            <QueryState isLoading={sessions.isLoading} isError={sessions.isError}>
              <TimeseriesChart
                points={sessions.data?.points ?? []}
                color="hsl(var(--chart-2))"
              />
            </QueryState>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Sonuçlar</CardTitle>
            <CardDescription>Günlük sonuç sayısı (son {days} gün)</CardDescription>
          </CardHeader>
          <CardContent>
            <QueryState isLoading={results.isLoading} isError={results.isError}>
              <TimeseriesChart
                points={results.data?.points ?? []}
                color="hsl(var(--chart-4))"
              />
            </QueryState>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle>Oyun Türü Dağılımı</CardTitle>
            <CardDescription>Türe göre oturum sayısı</CardDescription>
          </CardHeader>
          <CardContent>
            <QueryState isLoading={eng.isLoading} isError={eng.isError}>
              <CategoryBarChart data={gameTypeData} />
            </QueryState>
          </CardContent>
        </Card>

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-1">
          <StatCard
            title="Ortalama Skor"
            value={formatScore(eng.data?.averageScore)}
            icon={Award}
            loading={eng.isLoading}
          />
          <StatCard
            title="Paylaşım Oranı"
            value={formatPercent(eng.data?.sharedRate)}
            hint={`${formatNumber(eng.data?.sharedResults)} / ${formatNumber(eng.data?.totalResults)} sonuç`}
            icon={Share2}
            loading={eng.isLoading}
          />
        </div>
      </div>
    </div>
  );
}
