using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LingoCross.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class GamePublishing : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "is_published",
                table: "games",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "published_at",
                table: "games",
                type: "timestamp with time zone",
                nullable: true);

            // Backfill: M4'te otomatik üretilen mevcut oyunlar oynanabilir kalsın → yayımlanmış say.
            migrationBuilder.Sql(
                "UPDATE games SET is_published = TRUE, published_at = COALESCE(published_at, now());");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "is_published",
                table: "games");

            migrationBuilder.DropColumn(
                name: "published_at",
                table: "games");
        }
    }
}
