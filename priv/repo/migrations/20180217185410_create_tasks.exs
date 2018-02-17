defmodule Tasktracka.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :is_completed, :boolean, default: false, null: false
      add :title, :string, null: false
      add :description, :text #Design Decision: It's okay for a description to be empty
      add :minutes_worked, :integer, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tasks, [:user_id])
    create constraint("tasks", :minutes_must_be_pos, check: "minutes_worked > 0")
  end
end
