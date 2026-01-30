defmodule HomeTracker.Categories do
  alias HomeTracker.Dblayer.Category

  def list_categories, do: Category.list_categories()

  def get_category(id), do: Category.get_category(id)

  def get_category!(id), do: Category.get_category!(id)

  def create_category(attrs), do: Category.create_category(attrs)

  def update_category(category, attrs), do: Category.update_category(category, attrs)

  def delete_category(category), do: Category.delete_category(category)

  def find_by_name(name), do: Category.find_by_name(name)
end
