defmodule HomeTracker.Models.Container do
  use Ecto.Schema
  import Ecto.Changeset

  schema "containers" do
    field(:name, :string)
    has_many(:items, HomeTracker.Models.Item)

    timestamps()
  end

  def changeset(container, attrs) do
    container
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
