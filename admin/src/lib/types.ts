// API sözleşmesi tipleri (mevcut .NET admin uçları)

export interface LoginResponse {
  token: string;
  expiresAt: string; // ISO
}

export interface SubscriptionBreakdown {
  premiumActive: number;
  trial: number;
  canceled: number;
  expired: number;
  free: number;
}

export interface Overview {
  teacherCount: number;
  studentCount: number;
  totalUsers: number;
  activeClasses: number;
  lessons: number;
  words: number;
  publishedGames: number;
  sessions: number;
  results: number;
  averageScore: number | null;
  subscriptions: SubscriptionBreakdown;
  activeStudents7d: number;
  activeStudents30d: number;
}

export type TimeseriesMetric = "signups" | "sessions" | "results" | "subscriptions";

export interface TimeseriesPoint {
  date: string; // YYYY-MM-DD
  count: number;
}

export interface Timeseries {
  metric: TimeseriesMetric;
  days: number;
  points: TimeseriesPoint[];
}

export interface GameTypeStat {
  type: string;
  sessions: number;
}

export interface Engagement {
  gameTypes: GameTypeStat[];
  averageScore: number | null;
  totalResults: number;
  sharedResults: number;
  sharedRate: number;
}

export interface Subscriptions {
  statusBreakdown: SubscriptionBreakdown;
  bySource: GameTypeStat[];
  newSubscriptions: Timeseries;
}

export interface RecentUser {
  displayName: string;
  email: string;
  role: string;
  createdAt: string;
}

export interface RecentResult {
  studentName: string;
  lessonTitle: string;
  score: number;
  createdAt: string;
}

export interface Recent {
  users: RecentUser[];
  results: RecentResult[];
}
