defmodule HomeTracker.Dblayer.Container do
  alias HomeTracker.Repo
  alias HomeTracker.Models.Container

  def list_containers do
    Repo.all(Container)
  end

  def get_container(id) do
    Repo.get(Container, id)
  end

  def get_container!(id) do
    Repo.get!(Container, id)
  end

  def create_container(attrs) do
    %Container{}
    |> Container.changeset(attrs)
    |> Repo.insert()
  end

  def update_container(%Container{} = container, attrs) do
    container
    |> Container.changeset(attrs)
    |> Repo.update()
  end

  def delete_container(%Container{} = container) do
    Repo.delete(container)
  end

  def find_by_name(name) do
    Repo.get_by(Container, name: name)
  end
end
