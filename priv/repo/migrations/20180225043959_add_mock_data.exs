defmodule Tasktracka.Repo.Migrations.AddRoleTest do
  use Ecto.Migration

  alias Tasktracka.RoleManager
  alias Tasktracka.Accounts

  def change do
  	RoleManager.create_role(%{name: "User"})
  	RoleManager.create_role(%{name: "Manager"})
  	RoleManager.create_role(%{name: "Admin"})


  	Accounts.create_user(%{email: "admin@admin.com", name: "admin", role_id: 3})
  	Accounts.create_user(%{email: "user1@user1.com", name: "user1", role_id: 1})
  	Accounts.create_user(%{email: "user2@user2.com", name: "user2", role_id: 1})
  	Accounts.create_user(%{email: "user3@user3.com", name: "user3", role_id: 1})
  	Accounts.create_user(%{email: "user4@user4.com", name: "user4", role_id: 1})
  	Accounts.create_user(%{email: "user5@user5.com", name: "user5", role_id: 1})
  end
end
