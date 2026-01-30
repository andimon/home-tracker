defmodule HomeTracker.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string, null: false
      add :category_id, references(:categories, on_delete: :nilify_all)
      add :location, :string
      add :purchase_price, :decimal, precision: 10, scale: 2
      add :quantity, :integer, default: 1
      add :photo_url, :string
      add :receipt_url, :string
      add :notes, :text

      timestamps()
    end

    create index(:items, [:category_id])
    create index(:items, [:location])
  end
end
