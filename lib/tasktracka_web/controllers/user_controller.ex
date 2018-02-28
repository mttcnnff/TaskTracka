defmodule TasktrackaWeb.UserController do
  use TasktrackaWeb, :controller

  alias Tasktracka.Accounts
  alias Tasktracka.Accounts.User
  alias Tasktracka.RoleManager

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    role_id = RoleManager.get_role_by_name("User").id
    user_params = Map.put(user_params, "role_id", role_id)
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("#{inspect(changeset)}")
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    managers = Accounts.list_users_managers(id)
    managees = Accounts.list_team_by_manager_id(id)
    render(conn, "show.html", user: user, managers: managers, managees: managees)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def add_managee(conn, %{"user_id" => id}) do
    current_user = conn.assigns.current_user
    if current_user.role.name == "Manager" && current_user.id != id do 
      case Accounts.make_manager(%{manager_id: current_user.id, managee_id: id}) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: user_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:info, "Failed to update successfully.")
          |> redirect(to: user_path(conn, :index))
      end
    else
      conn
      |> put_flash(:info, "You can't do that!")
      |> redirect(to: user_path(conn, :index))
    end
  end

end
