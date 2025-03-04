defmodule Platform.Config do
  @moduledoc """
  The Config context.
  """

  import Ecto.Query, warn: false
  alias Platform.Repo

  alias Platform.Config.SystemSetup

  @doc """
  Returns the list of system_setups.

  ## Examples

      iex> list_system_setups()
      [%SystemSetup{}, ...]

  """
  def list_system_setups do
    Repo.all(SystemSetup)
  end

  @doc """
  Gets a single system_setup.

  Raises `Ecto.NoResultsError` if the System setup does not exist.

  ## Examples

      iex> get_system_setup!(123)
      %SystemSetup{}

      iex> get_system_setup!(456)
      ** (Ecto.NoResultsError)

  """
  def get_system_setup!(id), do: Repo.get!(SystemSetup, id)

  @doc """
  Creates a system_setup.

  ## Examples

      iex> create_system_setup(%{field: value})
      {:ok, %SystemSetup{}}

      iex> create_system_setup(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_system_setup(attrs \\ %{}) do
    %SystemSetup{}
    |> SystemSetup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a system_setup.

  ## Examples

      iex> update_system_setup(system_setup, %{field: new_value})
      {:ok, %SystemSetup{}}

      iex> update_system_setup(system_setup, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_system_setup(%SystemSetup{} = system_setup, attrs) do
    system_setup
    |> SystemSetup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a system_setup.

  ## Examples

      iex> delete_system_setup(system_setup)
      {:ok, %SystemSetup{}}

      iex> delete_system_setup(system_setup)
      {:error, %Ecto.Changeset{}}

  """
  def delete_system_setup(%SystemSetup{} = system_setup) do
    Repo.delete(system_setup)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking system_setup changes.

  ## Examples

      iex> change_system_setup(system_setup)
      %Ecto.Changeset{data: %SystemSetup{}}

  """
  def change_system_setup(%SystemSetup{} = system_setup, attrs \\ %{}) do
    SystemSetup.changeset(system_setup, attrs)
  end

  @doc ~S"""
  Checks whether a setup is completed.

  """
  def is_setup_completed?() do
    SystemSetup
    |> where([s], s.setup_completed == true)
    |> Repo.exists?()
  end

  @doc """
  Marks an installation as completed.

  """
  def mark_setup_as_completed() do
    create_system_setup(%{ setup_completed: true })
  end
end
