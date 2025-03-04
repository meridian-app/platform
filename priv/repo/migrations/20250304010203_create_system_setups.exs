defmodule Platform.Repo.Migrations.CreateSystemSetups do
  use Ecto.Migration

  def change do
    create table(:system_setups) do
      add :setup_completed, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
