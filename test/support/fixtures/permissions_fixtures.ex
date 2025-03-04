defmodule Platform.PermissionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Platform.Permissions` context.
  """

  @doc """
  Generate a unique role name.
  """
  def unique_role_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: unique_role_name()
      })
      |> Platform.Permissions.create_role()

    role
  end

  @doc """
  Generate a user_role.
  """
  def user_role_fixture(attrs \\ %{}) do
    {:ok, user_role} =
      attrs
      |> Enum.into(%{

      })
      |> Platform.Permissions.create_user_role()

    user_role
  end
end
