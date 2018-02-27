defmodule TasktrackaWeb.TimeBlockController do
  use TasktrackaWeb, :controller

  alias Tasktracka.Tracker
  alias Tasktracka.Tracker.TimeBlock

  action_fallback TasktrackaWeb.FallbackController

  def index(conn, _params) do
    timeblocks = Tracker.list_timeblocks()
    render(conn, "index.json", timeblocks: timeblocks)
  end

  def create(conn, %{"time_block" => time_block_params}) do
    # IO.puts("#{inspect(time_block_params)}")
    with {:ok, %TimeBlock{} = time_block} <- Tracker.create_time_block(time_block_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", time_block_path(conn, :show, time_block))
      |> render("show.json", time_block: time_block)
    end
  end

  def show(conn, %{"id" => id}) do
    time_block = Tracker.get_time_block!(id)
    render(conn, "show.json", time_block: time_block)
  end

  def update(conn, %{"id" => id, "time_block" => time_block_params}) do
    time_block = Tracker.get_time_block!(id)

    with {:ok, %TimeBlock{} = time_block} <- Tracker.update_time_block(time_block, time_block_params) do
      render(conn, "show.json", time_block: time_block)
    end
  end

  def delete(conn, %{"id" => id}) do
    time_block = Tracker.get_time_block!(id)
    with {:ok, %TimeBlock{}} <- Tracker.delete_time_block(time_block) do
      send_resp(conn, :no_content, "")
    end
  end

  def test(conn, params) do
    conn
    |> redirect(to: task_path(conn, :index))
  end
end
