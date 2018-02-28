defmodule Tasktracka.Tracker.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracka.Tracker.TimeBlock


  schema "timeblocks" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    field :task_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%TimeBlock{} = time_block, attrs) do
    time_block
    |> cast(attrs, [:task_id, :start, :end])
    |> validate_required([:task_id, :start])
  end
end
