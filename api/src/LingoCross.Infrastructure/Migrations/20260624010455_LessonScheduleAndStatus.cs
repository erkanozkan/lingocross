using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LingoCross.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class LessonScheduleAndStatus : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "scheduled_label",
                table: "lessons",
                type: "character varying(200)",
                maxLength: 200,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "status",
                table: "lessons",
                type: "integer",
                nullable: false,
                defaultValue: 1);

            // Backfill: mevcut yayımlanmış dersleri Active (2) durumuna taşı.
            // Yayımlanmamış dersler varsayılan Draft (1) olarak kalır.
            migrationBuilder.Sql("UPDATE lessons SET status = 2 WHERE is_published = true;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "scheduled_label",
                table: "lessons");

            migrationBuilder.DropColumn(
                name: "status",
                table: "lessons");
        }
    }
}
