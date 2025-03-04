defmodule Platform.Permissions.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_roles" do

    belongs_to :user, Platform.Accounts.Users, foreign_key: :user_id
    belongs_to :role, Platform.Permissions.Role, foreign_key: :role_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_id, :role_id])
    |> validate_required([:user_id, :role_id])
    |> unique_constraint(:user_id, name: :user_roles_user_id_role_id_index)
  end
end
