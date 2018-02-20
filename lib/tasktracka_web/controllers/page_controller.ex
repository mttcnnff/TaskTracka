defmodule TasktrackaWeb.PageController do
  use TasktrackaWeb, :controller

  alias Tasktracka.Tracker
  alias Tasktracka.Accounts
  alias Tasktracka.Tracker.Task
  alias Tasktracka.Accounts

  def index(conn, _params) do
  	if conn.assigns.current_user do
  		IO.puts("Render Home")
  		conn
  		|> redirect(to: page_path(conn, :todo))
  	else
  		IO.puts("Render Log In")
  		render(conn, "index.html")
  	end
  end

  def todo(conn, _params) do
  	if conn.assigns.current_user do
  		changeset = Tracker.change_task(%Task{})
    	users = Accounts.list_users()
    	tasks = Tracker.list_tasks_in_order()
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
        |> redirect(to: page_path(conn, :todo))
      {:error, %Ecto.Changeset{} = changeset} ->
        tasks = Tracker.list_tasks_in_order()
        render(conn, "todo.html", changeset: changeset, users: users, tasks: tasks)
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
      |> redirect(to: page_path(conn, :index))
    end
  end

  def update_todo(conn, %{"id" => id, "task" => task_params}) do
    task = Tracker.get_task!(id)

    case Tracker.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: page_path(conn, :todo))
      {:error, %Ecto.Changeset{} = changeset} ->
        tasks = Tracker.list_tasks_in_order()
        users = Accounts.list_users()
        render(conn, "todo.html", current_task: task, changeset: changeset, tasks: tasks, users: users)
    end
  end

  def delete_todo(conn, %{"id" => id}) do
    task = Tracker.get_task!(id)
    {:ok, _task} = Tracker.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: page_path(conn, :todo))
  end

end
