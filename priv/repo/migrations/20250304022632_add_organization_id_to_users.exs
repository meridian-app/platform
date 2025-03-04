defmodule Platform.Repo.Migrations.AddOrganizationIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:user) do
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false
    end

    create index(:user, [:organization_id])
  end
end
