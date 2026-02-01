defmodule HomeTracker.Containers do
  alias HomeTracker.Dblayer.Container

  def list_containers, do: Container.list_containers()

  def get_container(id), do: Container.get_container(id)

  def get_container!(id), do: Container.get_container!(id)

  def create_container(attrs), do: Container.create_container(attrs)

  def update_container(container, attrs), do: Container.update_container(container, attrs)

  def delete_container(container), do: Container.delete_container(container)

  def find_by_name(name), do: Container.find_by_name(name)
end
