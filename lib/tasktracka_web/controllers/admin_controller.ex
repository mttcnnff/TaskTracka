defmodule TasktrackaWeb.AdminController do
  use TasktrackaWeb, :controller

  alias Tasktracka.Tracker
  alias Tasktracka.Accounts
  alias Tasktracka.Tracker.Task
  alias Tasktracka.Accounts
  alias Tasktracka.RoleManager

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def update_role(conn, %{"new_role" => new_role, "user_id" => user_id}) do
    user = Accounts.get_user!(user_id)
    role = RoleManager.get_role_by_name(new_role)
    role_id = 
      case role do
        nil -> -1
        _ -> role.id
      end
    
    case Accounts.update_user(user, %{role_id: role_id}) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: admin_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, "User updated unsuccessfully.")
        |> redirect(to: admin_path(conn, :index))
    end

  end

  def make_manager(conn, %{"user_id" => user_id}) do
    admin = Accounts.get_userid_by_name("admin")
    case Accounts.make_manager(%{manager_id: admin.id, managee_id: user_id}) do
      {:ok, user} ->
        IO.puts("Updated successfully")
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("#{inspect(changeset)}")
    end
    update_role(conn, %{"new_role" => "Manager", "user_id" => user_id})
  end

  def remove_manager(conn, %{"user_id" => user_id}) do
    user = Accounts.get_user!(user_id)
    resp = Accounts.delete_manager_rels(user_id) 
    update_role(conn, %{"new_role" => "User", "user_id" => user_id})
  end

  def list_manages(conn, %{"user_id" => user_id}) do
    manages = Accounts.list_managees_by_manager_id(user_id)
    IO.puts("#{inspect(manages)}")
    conn
    |> redirect(to: admin_path(conn, :index))
  end

end