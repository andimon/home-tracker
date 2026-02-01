defmodule HomeTracker.Repo.Migrations.CreateContainers do
  use Ecto.Migration

  def change do
    create table(:containers) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:containers, [:name])
  end
end
