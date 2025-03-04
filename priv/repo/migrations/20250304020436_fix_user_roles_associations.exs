defmodule Platform.Repo.Migrations.FixUserRolesAssociations do
  use Ecto.Migration

  def change do
    # Drop the existing table if it exists
    drop_if_exists table(:user_roles)

    create table(:user_roles) do
      add :user_id, references(:user, on_delete: :delete_all), null: false
      add :role_id, references(:roles, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:user_roles, [:user_id, :role_id])
  end
end
