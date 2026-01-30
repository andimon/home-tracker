defmodule HomeTracker.Dblayer.Category do
  alias HomeTracker.Repo
  alias HomeTracker.Models.Category

  def list_categories do
    Repo.all(Category)
  end

  def get_category(id) do
    Repo.get(Category, id)
  end

  def get_category!(id) do
    Repo.get!(Category, id)
  end

  def create_category(attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def find_by_name(name) do
    Repo.get_by(Category, name: name)
  end
end
