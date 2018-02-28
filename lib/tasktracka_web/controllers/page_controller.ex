defmodule TasktrackaWeb.PageController do
  use TasktrackaWeb, :controller

  alias Tasktracka.Tracker
  alias Tasktracka.Accounts
  alias Tasktracka.Tracker.Task
  alias Tasktracka.Accounts

  def index(conn, _params) do
    if conn.assigns.current_user do
      IO.puts("User Logged In")
      case conn.assigns.current_user.role.name do
        "Admin" -> conn |> redirect(to: admin_path(conn, :index))
        "User" -> conn |> redirect(to: page_path(conn, :todo))
        "Manager" -> conn |> redirect(to: page_path(conn, :manage_todos))
      end
    else
      IO.puts("User Not Logged In")
      render(conn, "index.html")
    end
  end

  def profile(conn, _params) do
    if conn.assigns.current_user do
      user = conn.assigns.current_user
      managers = Accounts.list_users_managers(user.id)
      managees = Accounts.list_team_by_manager_id(user.id)
      render(conn, TasktrackaWeb.UserView, "show.html", user: user, managers: managers, managees: managees)
    else
      conn
      |> redirect(to: page_path(conn, :index))
    end
  end

  def todo(conn, _params) do
  	if conn.assigns.current_user do
      if conn.assigns.current_user.role.name == "Manager" do
        conn
        |> redirect(to: page_path(conn, :manage_todos))
      end
  		changeset = Tracker.change_task(%Task{})
      users = [conn.assigns.current_user]
    	tasks = Tracker.list_tasks_by_user_id(conn.assigns.current_user.id)
    	render(conn, "todo.html", changeset: changeset, users: users, tasks: tasks)
  	else
  		conn
  		|> redirect(to: page_path(conn, :index))
  	end
  end

  def manage_todos(conn, _params) do
    user = conn.assigns.current_user
    if user && user.role.name != "User" do
      changeset = Tracker.change_task(%Task{})
      users = Accounts.list_team_by_manager_id(conn.assigns.current_user.id) 
      |> Enum.to_list() 
      users = [conn.assigns.current_user] ++ users
      tasks = Tracker.list_tasks_by_user_id(conn.assigns.current_user.id)
      |> Enum.concat(Tracker.list_tasks_by_manager_id(conn.assigns.current_user.id))
      render(conn, "todo.html", changeset: changeset, users: users, tasks: tasks)
    else
      conn
      |> redirect(to: page_path(conn, :index))
    end
  end

  def create_todo(conn, %{"task" => task_params}) do
    users = Accounts.list_users()
    case Tracker.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: NavigationHistory.last_path(conn))
      {:error, %Ecto.Changeset{} = changeset} ->
        tasks = Tracker.list_tasks_in_order()
        IO.puts("#{inspect(changeset)}")
        conn
        |> redirect(to: NavigationHistory.last_path(conn))
    end
  end

  def edit_todo(conn, %{"id" => id}) do
    if conn.assigns.current_user do
      users = Accounts.list_users()
      tasks = Tracker.list_tasks_in_order()
      current_task = Tracker.get_task!(id)
      changeset = Tracker.change_task(current_task)
      render(conn, "todo.html", changeset: changeset, users: users, tasks: tasks, current_task: current_task)
    else
      conn
      |> redirect(to: NavigationHistory.last_path(conn))
    end
  end

  def update_todo(conn, %{"id" => id, "task" => task_params}) do
    task = Tracker.get_task!(id)

    case Tracker.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> redirect(to: NavigationHistory.last_path(conn))
    end
  end

  def delete_todo(conn, %{"id" => id}) do
    task = Tracker.get_task!(id)
    {:ok, _task} = Tracker.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: NavigationHistory.last_path(conn))
  end

end
