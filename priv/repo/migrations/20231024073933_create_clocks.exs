defmodule TimeManager.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :status, :boolean, default: true
      add :time, :naive_datetime
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
