import { BookOpen, ListChecks, Puzzle, Type } from "lucide-react";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { StatCard } from "@/components/dashboard/StatCard";
import { useOverview, useRecent } from "@/hooks/queries";
import { formatDateTime, formatNumber, formatScore } from "@/lib/utils";

function roleLabel(role: string): { text: string; variant: "default" | "secondary" } {
  const r = role.toLowerCase();
  if (r === "teacher" || r === "öğretmen")
    return { text: "Öğretmen", variant: "default" };
  return { text: "Öğrenci", variant: "secondary" };
}

export function ContentTab() {
  const { data: overview, isLoading } = useOverview();
  const recent = useRecent(20);

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
        <StatCard
          title="Aktif Sınıf"
          value={formatNumber(overview?.activeClasses)}
          icon={BookOpen}
          loading={isLoading}
        />
        <StatCard
          title="Ders"
          value={formatNumber(overview?.lessons)}
          icon={ListChecks}
          loading={isLoading}
        />
        <StatCard
          title="Kelime"
          value={formatNumber(overview?.words)}
          icon={Type}
          loading={isLoading}
        />
        <StatCard
          title="Bulmaca/Oyun"
          value={formatNumber(overview?.publishedGames)}
          icon={Puzzle}
          loading={isLoading}
        />
      </div>

      <div className="grid gap-4 lg:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Son Kullanıcılar</CardTitle>
            <CardDescription>En son katılan kullanıcılar</CardDescription>
          </CardHeader>
          <CardContent>
            {recent.isLoading ? (
              <Skeleton className="h-64 w-full" />
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Ad</TableHead>
                    <TableHead>E-posta</TableHead>
                    <TableHead>Rol</TableHead>
                    <TableHead>Tarih</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {(recent.data?.users ?? []).map((u, i) => {
                    const role = roleLabel(u.role);
                    return (
                      <TableRow key={i}>
                        <TableCell className="font-medium">
                          {u.displayName}
                        </TableCell>
                        <TableCell className="text-muted-foreground">
                          {u.email}
                        </TableCell>
                        <TableCell>
                          <Badge variant={role.variant}>{role.text}</Badge>
                        </TableCell>
                        <TableCell className="text-muted-foreground">
                          {formatDateTime(u.createdAt)}
                        </TableCell>
                      </TableRow>
                    );
                  })}
                  {!recent.isLoading && (recent.data?.users.length ?? 0) === 0 ? (
                    <TableRow>
                      <TableCell colSpan={4} className="text-center text-muted-foreground">
                        Kayıt yok
                      </TableCell>
                    </TableRow>
                  ) : null}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Son Sonuçlar</CardTitle>
            <CardDescription>En son tamamlanan oyunlar</CardDescription>
          </CardHeader>
          <CardContent>
            {recent.isLoading ? (
              <Skeleton className="h-64 w-full" />
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Öğrenci</TableHead>
                    <TableHead>Ders</TableHead>
                    <TableHead>Skor</TableHead>
                    <TableHead>Tarih</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {(recent.data?.results ?? []).map((r, i) => (
                    <TableRow key={i}>
                      <TableCell className="font-medium">{r.studentName}</TableCell>
                      <TableCell className="text-muted-foreground">
                        {r.lessonTitle}
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline">{formatScore(r.score)}</Badge>
                      </TableCell>
                      <TableCell className="text-muted-foreground">
                        {formatDateTime(r.createdAt)}
                      </TableCell>
                    </TableRow>
                  ))}
                  {!recent.isLoading && (recent.data?.results.length ?? 0) === 0 ? (
                    <TableRow>
                      <TableCell colSpan={4} className="text-center text-muted-foreground">
                        Sonuç yok
                      </TableCell>
                    </TableRow>
                  ) : null}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
