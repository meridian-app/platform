defmodule Platform.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :address, :string
    field :email, :string
    field :phone, :string

    has_many :users, Platform.Accounts.Users

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :email, :phone, :address])
    |> validate_required([:name, :email, :phone, :address])
    |> unique_constraint(:email)
  end
end
