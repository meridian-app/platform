defmodule Platform.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Platform.Organizations` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        address: "some address",
        email: "some email",
        name: "some name",
        phone: "some phone"
      })
      |> Platform.Organizations.create_organization()

    organization
  end
end
