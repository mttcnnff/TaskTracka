defmodule Tasktracka.Tracker.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracka.Tracker.Task


  schema "tasks" do
    field :description, :string
    field :is_completed, :boolean, default: false
    field :minutes_worked, :integer
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:is_completed, :title, :description, :minutes_worked])
    |> validate_required([:is_completed, :title, :description, :minutes_worked])
  end
end
