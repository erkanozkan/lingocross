using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LingoCross.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class MakeGameLessonNullableAddQuestionTopic : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_games_lesson_id_type",
                table: "games");

            migrationBuilder.AlterColumn<Guid>(
                name: "lesson_id",
                table: "games",
                type: "uuid",
                nullable: true,
                oldClrType: typeof(Guid),
                oldType: "uuid");

            migrationBuilder.AddColumn<Guid>(
                name: "question_topic_id",
                table: "games",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "ix_games_lesson_id_type",
                table: "games",
                columns: new[] { "lesson_id", "type" },
                unique: true,
                filter: "lesson_id IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "ix_games_question_topic_id",
                table: "games",
                column: "question_topic_id");

            migrationBuilder.CreateIndex(
                name: "ix_games_question_topic_id_type",
                table: "games",
                columns: new[] { "question_topic_id", "type" },
                unique: true,
                filter: "question_topic_id IS NOT NULL");

            migrationBuilder.AddCheckConstraint(
                name: "ck_games_lesson_xor_topic",
                table: "games",
                sql: "(lesson_id IS NULL) <> (question_topic_id IS NULL)");

            migrationBuilder.AddForeignKey(
                name: "fk_games_question_topics_question_topic_id",
                table: "games",
                column: "question_topic_id",
                principalTable: "question_topics",
                principalColumn: "id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_games_question_topics_question_topic_id",
                table: "games");

            migrationBuilder.DropIndex(
                name: "ix_games_lesson_id_type",
                table: "games");

            migrationBuilder.DropIndex(
                name: "ix_games_question_topic_id",
                table: "games");

            migrationBuilder.DropIndex(
                name: "ix_games_question_topic_id_type",
                table: "games");

            migrationBuilder.DropCheckConstraint(
                name: "ck_games_lesson_xor_topic",
                table: "games");

            migrationBuilder.DropColumn(
                name: "question_topic_id",
                table: "games");

            migrationBuilder.AlterColumn<Guid>(
                name: "lesson_id",
                table: "games",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"),
                oldClrType: typeof(Guid),
                oldType: "uuid",
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "ix_games_lesson_id_type",
                table: "games",
                columns: new[] { "lesson_id", "type" },
                unique: true);
        }
    }
}
