defmodule Tasktracka.Repo.Migrations.CreateTimeblocks do
  use Ecto.Migration

  def change do
    create table(:timeblocks) do
      add :task_id, :integer
      add :start, :naive_datetime
      add :end, :naive_datetime

      timestamps()
    end

  end
end
