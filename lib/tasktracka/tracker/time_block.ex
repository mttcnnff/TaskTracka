defmodule Tasktracka.Tracker.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracka.Tracker.TimeBlock


  schema "timeblocks" do
    field :end, :utc_datetime
    field :start, :utc_datetime
    field :task_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%TimeBlock{} = time_block, attrs) do
    # IO.puts("#{inspect(attrs)}")
    IO.puts("#{inspect(%TimeBlock{} |> cast(attrs, [:task_id, :start, :end]))}")
    time_block
    |> cast(attrs, [:task_id, :start, :end])
    |> validate_required([:task_id, :start, :end])
  end
end
