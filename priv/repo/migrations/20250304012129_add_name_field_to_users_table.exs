defmodule Platform.Repo.Migrations.AddNameFieldToUsersTable do
  use Ecto.Migration

  def up do
    alter table(:user) do
      add :name, :string, null: true
    end
  end

  def down do
    alter table(:user) do
      remove :name
    end
  end
end
