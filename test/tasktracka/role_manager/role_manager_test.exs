defmodule Tasktracka.RoleManagerTest do
  use Tasktracka.DataCase

  alias Tasktracka.RoleManager

  describe "roles" do
    alias Tasktracka.RoleManager.Role

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> RoleManager.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert RoleManager.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert RoleManager.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = RoleManager.create_role(@valid_attrs)
      assert role.name == "some name"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RoleManager.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, role} = RoleManager.update_role(role, @update_attrs)
      assert %Role{} = role
      assert role.name == "some updated name"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = RoleManager.update_role(role, @invalid_attrs)
      assert role == RoleManager.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = RoleManager.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> RoleManager.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = RoleManager.change_role(role)
    end
  end
end
