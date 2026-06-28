using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LingoCross.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddPasswordResetAttempts : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "attempts",
                table: "password_reset_tokens",
                type: "integer",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "attempts",
                table: "password_reset_tokens");
        }
    }
}
