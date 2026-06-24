using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LingoCross.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddGameResultItems : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "game_result_items",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false, defaultValueSql: "gen_random_uuid()"),
                    result_id = table.Column<Guid>(type: "uuid", nullable: false),
                    ordinal = table.Column<int>(type: "integer", nullable: false),
                    term = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    expected_answer = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    student_answer = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                    is_correct = table.Column<bool>(type: "boolean", nullable: false),
                    created_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updated_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_game_result_items", x => x.id);
                    table.ForeignKey(
                        name: "fk_game_result_items_game_results_result_id",
                        column: x => x.result_id,
                        principalTable: "game_results",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_game_result_items_result_id_ordinal",
                table: "game_result_items",
                columns: new[] { "result_id", "ordinal" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "game_result_items");
        }
    }
}
