defmodule HomeTracker.Items do
  alias HomeTracker.Dblayer.Items
  alias HomeTracker.Categories

  def list_items, do: Items.list_items()

  def get_item(id), do: Items.get_item(id)

  def get_item!(id), do: Items.get_item!(id)

  def create_item(item_name, category_name) do
    with {:ok, category} <- find_category(category_name),
         attrs <- %{name: item_name, category_id: category.id},
         {:ok, item} <- Items.create_item(attrs) do
      {:ok, item}
    end
  end

  def create_item(attrs), do: Items.create_item(attrs)

  def update_item(item, attrs), do: Items.update_item(item, attrs)

  def delete_item(item), do: Items.delete_item(item)

  def list_by_category(category_id), do: Items.list_by_category(category_id)

  def search_items(query), do: Items.search_items(query)

  defp find_category(name) do
    case Categories.find_by_name(name) do
      nil -> {:error, :category_not_found}
      category -> {:ok, category}
    end
  end
end
