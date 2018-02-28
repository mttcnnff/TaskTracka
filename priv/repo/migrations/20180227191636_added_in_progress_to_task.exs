defmodule Tasktracka.Repo.Migrations.AddedInProgressToTask do
  use Ecto.Migration

  def change do
  	alter table(:tasks) do
      add :in_progress, :boolean, default: false, null: false

    end

  end
end
