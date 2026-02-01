defmodule HomeTracker.Models.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field(:name, :string)
    belongs_to(:category, HomeTracker.Models.Category)
    belongs_to(:container, HomeTracker.Models.Container)
    field(:purchase_price, :decimal)
    field(:quantity, :integer, default: 1)
    field(:notes, :string)
    field(:receipt_url, :string, default: "")
    field(:photo_url, :string, default: "")

    timestamps()
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [
      :name,
      :category_id,
      :container_id,
      :purchase_price,
      :quantity,
      :photo_url,
      :receipt_url,
      :notes
    ])
    |> validate_required([:name])
    |> validate_number(:quantity, greater_than: 0)
    |> validate_number(:purchase_price, greater_than_or_equal_to: 0)
    |> assoc_constraint(:category)
    |> assoc_constraint(:container)
  end
end
