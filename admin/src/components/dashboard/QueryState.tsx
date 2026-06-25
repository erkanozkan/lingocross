import type { ReactNode } from "react";
import { AlertCircle } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";

interface QueryStateProps {
  isLoading: boolean;
  isError: boolean;
  children: ReactNode;
  /** Yükleme iskelet yüksekliği (px). */
  skeletonHeight?: number;
}

/** Sorgu loading/error durumlarını sarmalayan yardımcı. */
export function QueryState({
  isLoading,
  isError,
  children,
  skeletonHeight = 240,
}: QueryStateProps) {
  if (isLoading) {
    return <Skeleton style={{ height: skeletonHeight }} className="w-full" />;
  }
  if (isError) {
    return (
      <div
        className="flex w-full flex-col items-center justify-center gap-2 rounded-md border border-dashed text-muted-foreground"
        style={{ height: skeletonHeight }}
      >
        <AlertCircle className="h-6 w-6" />
        <span className="text-sm">Veri yüklenemedi.</span>
      </div>
    );
  }
  return <>{children}</>;
}
