defmodule Platform.ConfigTest do
  use Platform.DataCase

  alias Platform.Config

  describe "system_setups" do
    alias Platform.Config.SystemSetup

    import Platform.ConfigFixtures

    @invalid_attrs %{setup_completed: nil}

    test "list_system_setups/0 returns all system_setups" do
      system_setup = system_setup_fixture()
      assert Config.list_system_setups() == [system_setup]
    end

    test "get_system_setup!/1 returns the system_setup with given id" do
      system_setup = system_setup_fixture()
      assert Config.get_system_setup!(system_setup.id) == system_setup
    end

    test "create_system_setup/1 with valid data creates a system_setup" do
      valid_attrs = %{setup_completed: true}

      assert {:ok, %SystemSetup{} = system_setup} = Config.create_system_setup(valid_attrs)
      assert system_setup.setup_completed == true
    end

    test "create_system_setup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Config.create_system_setup(@invalid_attrs)
    end

    test "update_system_setup/2 with valid data updates the system_setup" do
      system_setup = system_setup_fixture()
      update_attrs = %{setup_completed: false}

      assert {:ok, %SystemSetup{} = system_setup} = Config.update_system_setup(system_setup, update_attrs)
      assert system_setup.setup_completed == false
    end

    test "update_system_setup/2 with invalid data returns error changeset" do
      system_setup = system_setup_fixture()
      assert {:error, %Ecto.Changeset{}} = Config.update_system_setup(system_setup, @invalid_attrs)
      assert system_setup == Config.get_system_setup!(system_setup.id)
    end

    test "delete_system_setup/1 deletes the system_setup" do
      system_setup = system_setup_fixture()
      assert {:ok, %SystemSetup{}} = Config.delete_system_setup(system_setup)
      assert_raise Ecto.NoResultsError, fn -> Config.get_system_setup!(system_setup.id) end
    end

    test "change_system_setup/1 returns a system_setup changeset" do
      system_setup = system_setup_fixture()
      assert %Ecto.Changeset{} = Config.change_system_setup(system_setup)
    end
  end
end
