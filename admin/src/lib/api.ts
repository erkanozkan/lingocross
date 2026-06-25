import axios from "axios";
import { clearAuth, getToken } from "./auth";
import type {
  Engagement,
  LoginResponse,
  Overview,
  Recent,
  Subscriptions,
  Timeseries,
  TimeseriesMetric,
} from "./types";

const baseURL = import.meta.env.VITE_API_BASE_URL ?? "";

export const api = axios.create({ baseURL });

// İstek interceptor: Bearer token ekle
api.interceptors.request.use((config) => {
  const token = getToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Yanıt interceptor: 401 → token temizle + login'e yönlendir
api.interceptors.response.use(
  (res) => res,
  (error) => {
    if (error?.response?.status === 401) {
      clearAuth();
      if (window.location.pathname !== "/login") {
        window.location.href = "/login";
      }
    }
    return Promise.reject(error);
  },
);

// --- Uç çağrıları ---

export async function login(email: string, password: string): Promise<LoginResponse> {
  const { data } = await api.post<LoginResponse>("/api/admin/login", { email, password });
  return data;
}

export async function fetchOverview(): Promise<Overview> {
  const { data } = await api.get<Overview>("/api/admin/overview");
  return data;
}

export async function fetchTimeseries(
  metric: TimeseriesMetric,
  days: number,
): Promise<Timeseries> {
  const { data } = await api.get<Timeseries>("/api/admin/timeseries", {
    params: { metric, days },
  });
  return data;
}

export async function fetchEngagement(): Promise<Engagement> {
  const { data } = await api.get<Engagement>("/api/admin/engagement");
  return data;
}

export async function fetchSubscriptions(days: number): Promise<Subscriptions> {
  const { data } = await api.get<Subscriptions>("/api/admin/subscriptions", {
    params: { days },
  });
  return data;
}

export async function fetchRecent(take = 20): Promise<Recent> {
  const { data } = await api.get<Recent>("/api/admin/recent", { params: { take } });
  return data;
}

/** Axios hatasından okunur Türkçe mesaj çıkar. */
export function errorMessage(error: unknown): string {
  if (axios.isAxiosError(error)) {
    const status = error.response?.status;
    if (status === 401) return "E-posta veya parola hatalı.";
    if (status === 503) return "Yönetim girişi yapılandırılmamış.";
    if (status) return `Sunucu hatası (${status}).`;
    return "Sunucuya ulaşılamadı.";
  }
  return "Beklenmeyen bir hata oluştu.";
}
