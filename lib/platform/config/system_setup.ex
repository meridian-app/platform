defmodule Platform.Config.SystemSetup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "system_setups" do
    field :setup_completed, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(system_setup, attrs) do
    system_setup
    |> cast(attrs, [:setup_completed])
    |> validate_required([:setup_completed])
  end
end
