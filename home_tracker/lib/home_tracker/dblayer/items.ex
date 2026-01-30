defmodule HomeTracker.Dblayer.Items do
  import Ecto.Query
  alias HomeTracker.Repo
  alias HomeTracker.Models.Item

  def list_items do
    Item
    |> preload(:category)
    |> Repo.all()
  end

  def get_item(id) do
    Item
    |> preload(:category)
    |> Repo.get(id)
  end

  def get_item!(id) do
    Item
    |> preload(:category)
    |> Repo.get!(id)
  end

  def create_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def list_by_category(category_id) do
    Item
    |> where([i], i.category_id == ^category_id)
    |> preload(:category)
    |> Repo.all()
  end

  def list_by_location(location) do
    Item
    |> where([i], i.location == ^location)
    |> preload(:category)
    |> Repo.all()
  end

  def search_items(query) do
    search = "%#{query}%"

    Item
    |> where([i], like(i.name, ^search) or like(i.notes, ^search))
    |> preload(:category)
    |> Repo.all()
  end
end
