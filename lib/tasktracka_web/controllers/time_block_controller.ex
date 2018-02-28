defmodule TasktrackaWeb.TimeBlockController do
  use TasktrackaWeb, :controller

  alias Tasktracka.Tracker
  alias Tasktracka.Tracker.TimeBlock

  def index(conn, _params) do
    timeblocks = Tracker.list_timeblocks()
    render(conn, "index.html", timeblocks: timeblocks, task: nil)
  end

  def new(conn, %{"task_id" => task_id} = _params) do
    changeset = Tracker.change_time_block(%TimeBlock{})
    render(conn, "new.html", changeset: changeset, task_id: task_id)
  end

  def new(conn, %{} = _params) do
    changeset = Tracker.change_time_block(%TimeBlock{})
    render(conn, "new.html", changeset: changeset, task_id: nil)
  end

  def create(conn, %{"time_block" => time_block_params} = params) do
    if Map.has_key?(params, "task_id") do
      time_block_params = Map.put(time_block_params, "task_id", params["task_id"])    
    end

    IO.puts("#{inspect(time_block_params)}")
    
    case Tracker.create_time_block(time_block_params) do
      {:ok, time_block} ->
        conn
        |> put_flash(:info, "Time block created successfully.")
        |> redirect(to: NavigationHistory.last_path(conn, 1))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    time_block = Tracker.get_time_block!(id)
    render(conn, "show.html", time_block: time_block)
  end

  def edit(conn, %{"id" => id}) do
    time_block = Tracker.get_time_block!(id)
    changeset = Tracker.change_time_block(time_block)
    render(conn, "edit.html", time_block: time_block, changeset: changeset)
  end

  def update(conn, %{"id" => id, "time_block" => time_block_params}) do
    time_block = Tracker.get_time_block!(id)

    case Tracker.update_time_block(time_block, time_block_params) do
      {:ok, time_block} ->
        conn
        |> put_flash(:info, "Time block updated successfully.")
        |> redirect(to: time_block_path(conn, :show, time_block))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", time_block: time_block, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    time_block = Tracker.get_time_block!(id)
    {:ok, _time_block} = Tracker.delete_time_block(time_block)

    conn
    |> put_flash(:info, "Time block deleted successfully.")
    |> redirect(to: NavigationHistory.last_path(conn))
  end
end
