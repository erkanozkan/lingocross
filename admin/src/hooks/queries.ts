import { useQuery } from "@tanstack/react-query";
import {
  fetchEngagement,
  fetchOverview,
  fetchRecent,
  fetchSubscriptions,
  fetchTimeseries,
} from "@/lib/api";
import type { TimeseriesMetric } from "@/lib/types";

const STALE = 60_000; // 1 dk

export function useOverview() {
  return useQuery({
    queryKey: ["overview"],
    queryFn: fetchOverview,
    staleTime: STALE,
  });
}

export function useTimeseries(metric: TimeseriesMetric, days: number) {
  return useQuery({
    queryKey: ["timeseries", metric, days],
    queryFn: () => fetchTimeseries(metric, days),
    staleTime: STALE,
  });
}

export function useEngagement() {
  return useQuery({
    queryKey: ["engagement"],
    queryFn: fetchEngagement,
    staleTime: STALE,
  });
}

export function useSubscriptions(days: number) {
  return useQuery({
    queryKey: ["subscriptions", days],
    queryFn: () => fetchSubscriptions(days),
    staleTime: STALE,
  });
}

export function useRecent(take = 20) {
  return useQuery({
    queryKey: ["recent", take],
    queryFn: () => fetchRecent(take),
    staleTime: STALE,
  });
}
