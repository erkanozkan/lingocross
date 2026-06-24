using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LingoCross.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class BackfillDefaultClasses : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // F4.3 backfill. Uygulama açılışta Database.MigrateAsync() ile bunu prod'da OTOMATİK uygular,
            // bu yüzden HER ADIM idempotent ve tek-sefer güvenli olmalıdır (ON CONFLICT DO NOTHING /
            // NOT EXISTS koruması). users.invite_code ve enrollments tablosu KORUNUR (silinmez).

            // 1) Her öğretmen (role=Teacher) için bir "Sınıfım" sınıfı oluştur; öğretmenin mevcut
            //    users.invite_code'unu bu sınıfa TAŞI (kopyala — users.invite_code silinmez). Yalnızca
            //    o öğretmenin hiç sınıfı yoksa eklenir → tekrar çalıştırmada hiçbir şey eklenmez.
            migrationBuilder.Sql(@"
INSERT INTO classes (id, teacher_id, name, invite_code, is_archived, created_at, updated_at)
SELECT gen_random_uuid(), u.id, 'Sınıfım', u.invite_code, false, now(), now()
FROM users u
WHERE u.role = 1
  AND NOT EXISTS (SELECT 1 FROM classes c WHERE c.teacher_id = u.id);
");

            // 2) Mevcut Active enrollment'lar → ilgili öğretmenin default ('Sınıfım') sınıfına Active üye.
            //    (class_id, student_id) benzersiz → ON CONFLICT DO NOTHING ile idempotent.
            //    Default sınıf: öğretmenin en eski (created_at, sonra id) sınıfı.
            migrationBuilder.Sql(@"
INSERT INTO class_members (id, class_id, student_id, status, created_at, updated_at)
SELECT gen_random_uuid(), dc.class_id, e.student_id, 1, now(), now()
FROM enrollments e
JOIN (
    SELECT DISTINCT ON (c.teacher_id) c.teacher_id, c.id AS class_id
    FROM classes c
    ORDER BY c.teacher_id, c.created_at, c.id
) dc ON dc.teacher_id = e.teacher_id
WHERE e.status = 2
ON CONFLICT (class_id, student_id) DO NOTHING;
");

            // 3) Mevcut yayınlı (is_published=true) oyunlar → dersin öğretmeninin default sınıfına atama.
            //    (game_id, class_id) benzersiz → ON CONFLICT DO NOTHING ile idempotent.
            migrationBuilder.Sql(@"
INSERT INTO game_assignments (id, game_id, class_id, created_at, updated_at)
SELECT gen_random_uuid(), g.id, dc.class_id, now(), now()
FROM games g
JOIN lessons l ON l.id = g.lesson_id
JOIN (
    SELECT DISTINCT ON (c.teacher_id) c.teacher_id, c.id AS class_id
    FROM classes c
    ORDER BY c.teacher_id, c.created_at, c.id
) dc ON dc.teacher_id = l.teacher_id
WHERE g.is_published = true
ON CONFLICT (game_id, class_id) DO NOTHING;
");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Veri taşıma migration'ı; geri alma kapsam dışı. Tablolar M-A (NamedClasses) ile düşer.
        }
    }
}
