defmodule TasktrackaWeb.TimeBlockView do
  use TasktrackaWeb, :view
  alias TasktrackaWeb.TimeBlockView

  def render("index.json", %{timeblocks: timeblocks}) do
    %{data: render_many(timeblocks, TimeBlockView, "time_block.json")}
  end

  def render("show.json", %{time_block: time_block}) do
    %{data: render_one(time_block, TimeBlockView, "time_block.json")}
  end

  def render("time_block.json", %{time_block: time_block}) do
    %{id: time_block.id,
      task_id: time_block.task_id,
      start: time_block.start,
      end: time_block.end}
  end
end
