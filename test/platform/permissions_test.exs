defmodule Platform.PermissionsTest do
  use Platform.DataCase

  alias Platform.Permissions

  describe "roles" do
    alias Platform.Permissions.Role

    import Platform.PermissionsFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Permissions.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Permissions.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Role{} = role} = Permissions.create_role(valid_attrs)
      assert role.name == "some name"
      assert role.description == "some description"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Permissions.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Role{} = role} = Permissions.update_role(role, update_attrs)
      assert role.name == "some updated name"
      assert role.description == "some updated description"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Permissions.update_role(role, @invalid_attrs)
      assert role == Permissions.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Permissions.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Permissions.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Permissions.change_role(role)
    end
  end

  describe "user_roles" do
    alias Platform.Permissions.UserRole

    import Platform.PermissionsFixtures

    @invalid_attrs %{}

    test "list_user_roles/0 returns all user_roles" do
      user_role = user_role_fixture()
      assert Permissions.list_user_roles() == [user_role]
    end

    test "get_user_role!/1 returns the user_role with given id" do
      user_role = user_role_fixture()
      assert Permissions.get_user_role!(user_role.id) == user_role
    end

    test "create_user_role/1 with valid data creates a user_role" do
      valid_attrs = %{}

      assert {:ok, %UserRole{} = user_role} = Permissions.create_user_role(valid_attrs)
    end

    test "create_user_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Permissions.create_user_role(@invalid_attrs)
    end

    test "update_user_role/2 with valid data updates the user_role" do
      user_role = user_role_fixture()
      update_attrs = %{}

      assert {:ok, %UserRole{} = user_role} = Permissions.update_user_role(user_role, update_attrs)
    end

    test "update_user_role/2 with invalid data returns error changeset" do
      user_role = user_role_fixture()
      assert {:error, %Ecto.Changeset{}} = Permissions.update_user_role(user_role, @invalid_attrs)
      assert user_role == Permissions.get_user_role!(user_role.id)
    end

    test "delete_user_role/1 deletes the user_role" do
      user_role = user_role_fixture()
      assert {:ok, %UserRole{}} = Permissions.delete_user_role(user_role)
      assert_raise Ecto.NoResultsError, fn -> Permissions.get_user_role!(user_role.id) end
    end

    test "change_user_role/1 returns a user_role changeset" do
      user_role = user_role_fixture()
      assert %Ecto.Changeset{} = Permissions.change_user_role(user_role)
    end
  end
end
