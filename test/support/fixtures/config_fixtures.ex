defmodule Platform.ConfigFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Platform.Config` context.
  """

  @doc """
  Generate a system_setup.
  """
  def system_setup_fixture(attrs \\ %{}) do
    {:ok, system_setup} =
      attrs
      |> Enum.into(%{
        setup_completed: true
      })
      |> Platform.Config.create_system_setup()

    system_setup
  end
end
