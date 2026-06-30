using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LingoCross.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddAiQuestionTopicFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "kind",
                table: "questions",
                type: "character varying(40)",
                maxLength: 40,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "grade",
                table: "question_topics",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "lesson_id",
                table: "question_topics",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "teacher_id",
                table: "question_topics",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "ix_question_topics_lesson_id",
                table: "question_topics",
                column: "lesson_id");

            migrationBuilder.CreateIndex(
                name: "ix_question_topics_teacher_id",
                table: "question_topics",
                column: "teacher_id");

            migrationBuilder.AddForeignKey(
                name: "fk_question_topics_lessons_lesson_id",
                table: "question_topics",
                column: "lesson_id",
                principalTable: "lessons",
                principalColumn: "id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "fk_question_topics_users_teacher_id",
                table: "question_topics",
                column: "teacher_id",
                principalTable: "users",
                principalColumn: "id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_question_topics_lessons_lesson_id",
                table: "question_topics");

            migrationBuilder.DropForeignKey(
                name: "fk_question_topics_users_teacher_id",
                table: "question_topics");

            migrationBuilder.DropIndex(
                name: "ix_question_topics_lesson_id",
                table: "question_topics");

            migrationBuilder.DropIndex(
                name: "ix_question_topics_teacher_id",
                table: "question_topics");

            migrationBuilder.DropColumn(
                name: "kind",
                table: "questions");

            migrationBuilder.DropColumn(
                name: "grade",
                table: "question_topics");

            migrationBuilder.DropColumn(
                name: "lesson_id",
                table: "question_topics");

            migrationBuilder.DropColumn(
                name: "teacher_id",
                table: "question_topics");
        }
    }
}
