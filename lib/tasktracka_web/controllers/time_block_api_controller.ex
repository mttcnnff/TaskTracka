defmodule TasktrackaWeb.TimeBlockApiController do
  use TasktrackaWeb, :controller

  alias Tasktracka.Tracker
  alias Tasktracka.Tracker.TimeBlock

  action_fallback TasktrackaWeb.FallbackController

  def index(conn, _params) do
    timeblocks = Tracker.list_timeblocks()
    render(conn, "index.json", timeblocks: timeblocks)
  end

  def create(conn, %{"time_block" => time_block_params}) do
    IO.puts("#{inspect(time_block_params)}")
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

  defp now do
    NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
  end

  def startstop(conn, _params = %{"params" => %{"action" => action, "task_id" => task_id}}) do
    IO.puts("#{inspect(_params)}")
    task = Tracker.get_task!(task_id)
    task_params = 
      case action do
        "start" -> %{"in_progress" => true}
        "stop" -> %{"in_progress" => false}
        _ -> 
      end

    open_time_block = Tracker.get_open_time_block(task_id)

    if task_params["in_progress"] != task.in_progress do

      {status, rest} = 
       case action do
         "start" -> 
            time_block_params = %{"task_id" => task_id, "start" => now(), "end" => nil }
            Tracker.create_time_block(time_block_params)
         "stop" -> 
            time_block_params =  %{"end" => now()}
            Tracker.update_time_block(open_time_block, time_block_params)
       end

      

      if status == :ok do
        Tracker.update_task(task, task_params)
      else 
        IO.puts("#{inspect(rest)}")
      end
    end
    send_resp(conn, :no_content, "")
    # conn
    #   |> put_status(:created)
      # |> put_resp_header("location", time_block_path(conn, :show, time_block))
      # |> render("show.json", time_block: time_block)
  end
end
