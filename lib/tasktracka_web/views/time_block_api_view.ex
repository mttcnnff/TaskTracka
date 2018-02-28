defmodule TasktrackaWeb.TimeBlockApiView do
  use TasktrackaWeb, :view
  alias TasktrackaWeb.TimeBlockApiView
  alias TasktrackaWeb.TimeBlockView

  def render("index.json", %{timeblocks: timeblocks}) do
    IO.puts("#{inspect(timeblocks)}")
    %{data: render_many(timeblocks, TimeBlockApiView, "time_block_api.json")}
  end

  def render("show.json", %{time_block_api: time_block_api}) do
    %{data: render_one(time_block_api, TimeBlockApiView, "time_block_api.json")}
  end

  def render("time_block_api.json", %{time_block_api: time_block_api}) do
    %{id: time_block_api.id}
  end
end
