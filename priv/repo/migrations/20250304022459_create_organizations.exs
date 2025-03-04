defmodule Platform.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :phone, :string, null: false
      add :address, :text, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:organizations, [:email])
  end
end
