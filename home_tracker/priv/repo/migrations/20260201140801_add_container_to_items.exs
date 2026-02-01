defmodule HomeTracker.Repo.Migrations.AddContainerToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :container_id, references(:containers, on_delete: :nilify_all)
    end

    create index(:items, [:container_id])
  end
end
