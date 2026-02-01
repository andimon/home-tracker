defmodule HomeTrackerUiWeb.HomeLive do
  use HomeTrackerUiWeb, :live_view

  alias HomeTracker.Items
  alias HomeTracker.Categories
  alias HomeTracker.Containers

  @impl true
  def mount(_params, _session, socket) do
    all_items = Items.list_items()

    {:ok,
     socket
     |> assign(:all_items, all_items)
     |> assign(:items, all_items)
     |> assign(:categories, Categories.list_categories())
     |> assign(:containers, Containers.list_containers())
     |> assign(:show_item_form, false)
     |> assign(:show_category_form, false)
     |> assign(:show_container_form, false)
     |> assign(:editing_item, nil)
     |> assign(:search_query, "")
     |> assign(:filter_category, nil)
     |> assign_new_item_form()
     |> assign_new_category_form()
     |> assign_new_container_form()}
  end

  defp assign_new_item_form(socket) do
    assign(socket, :item_form, %{
      "name" => "",
      "category_id" => "",
      "container_id" => "",
      "purchase_price" => "",
      "quantity" => "1",
      "notes" => "",
      "photo_url" => "",
      "receipt_url" => ""
    })
  end

  defp assign_new_category_form(socket) do
    assign(socket, :category_form, %{"name" => ""})
  end

  defp assign_new_container_form(socket) do
    assign(socket, :container_form, %{"name" => ""})
  end

  defp reload_items(socket) do
    all_items = Items.list_items()
    items = filter_items(all_items, socket.assigns.search_query, socket.assigns.filter_category)

    socket
    |> assign(:all_items, all_items)
    |> assign(:items, items)
  end

  @impl true
  def handle_event("toggle_item_form", _, socket) do
    {:noreply,
     socket
     |> assign(:show_item_form, !socket.assigns.show_item_form)
     |> assign(:editing_item, nil)
     |> assign_new_item_form()}
  end

  def handle_event("toggle_category_form", _, socket) do
    {:noreply, assign(socket, :show_category_form, !socket.assigns.show_category_form)}
  end

  def handle_event("toggle_container_form", _, socket) do
    {:noreply, assign(socket, :show_container_form, !socket.assigns.show_container_form)}
  end

  def handle_event("update_item_form", %{"field" => field, "value" => value}, socket) do
    form = Map.put(socket.assigns.item_form, field, value)
    {:noreply, assign(socket, :item_form, form)}
  end

  def handle_event("update_item_form_all", params, socket) do
    form = %{
      "name" => params["name"] || "",
      "category_id" => params["category_id"] || "",
      "container_id" => params["container_id"] || "",
      "purchase_price" => params["purchase_price"] || "",
      "quantity" => params["quantity"] || "1",
      "notes" => params["notes"] || "",
      "photo_url" => params["photo_url"] || "",
      "receipt_url" => params["receipt_url"] || ""
    }
    {:noreply, assign(socket, :item_form, form)}
  end

  def handle_event("update_category_form", %{"field" => field, "value" => value}, socket) do
    form = Map.put(socket.assigns.category_form, field, value)
    {:noreply, assign(socket, :category_form, form)}
  end

  def handle_event("update_container_form", %{"field" => field, "value" => value}, socket) do
    form = Map.put(socket.assigns.container_form, field, value)
    {:noreply, assign(socket, :container_form, form)}
  end

  def handle_event("save_item", params, socket) do
    form = params

    attrs = %{
      name: form["name"],
      category_id: parse_int(form["category_id"]),
      container_id: parse_int(form["container_id"]),
      purchase_price: parse_decimal(form["purchase_price"]),
      quantity: parse_int(form["quantity"]) || 1,
      notes: form["notes"],
      photo_url: form["photo_url"],
      receipt_url: form["receipt_url"]
    }

    case socket.assigns.editing_item do
      nil ->
        case Items.create_item(attrs) do
          {:ok, _item} ->
            {:noreply,
             socket
             |> reload_items()
             |> assign(:show_item_form, false)
             |> assign_new_item_form()}

          {:error, _changeset} ->
            {:noreply, socket}
        end

      item ->
        case Items.update_item(item, attrs) do
          {:ok, _item} ->
            {:noreply,
             socket
             |> reload_items()
             |> assign(:show_item_form, false)
             |> assign(:editing_item, nil)
             |> assign_new_item_form()}

          {:error, _changeset} ->
            {:noreply, socket}
        end
    end
  end

  def handle_event("save_category", _, socket) do
    form = socket.assigns.category_form

    case Categories.create_category(%{name: form["name"]}) do
      {:ok, _category} ->
        {:noreply,
         socket
         |> assign(:categories, Categories.list_categories())
         |> assign(:show_category_form, false)
         |> assign_new_category_form()}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_event("edit_item", %{"id" => id}, socket) do
    item = Items.get_item!(String.to_integer(id))

    form = %{
      "name" => item.name || "",
      "category_id" => to_string(item.category_id || ""),
      "container_id" => to_string(item.container_id || ""),
      "purchase_price" => to_string(item.purchase_price || ""),
      "quantity" => to_string(item.quantity || 1),
      "notes" => item.notes || "",
      "photo_url" => item.photo_url || "",
      "receipt_url" => item.receipt_url || ""
    }

    {:noreply,
     socket
     |> assign(:editing_item, item)
     |> assign(:item_form, form)
     |> assign(:show_item_form, true)}
  end

  def handle_event("delete_item", %{"id" => id}, socket) do
    item = Items.get_item!(String.to_integer(id))
    {:ok, _} = Items.delete_item(item)

    {:noreply, reload_items(socket)}
  end

  def handle_event("delete_category", %{"id" => id}, socket) do
    category = Categories.get_category!(String.to_integer(id))
    {:ok, _} = Categories.delete_category(category)

    {:noreply, assign(socket, :categories, Categories.list_categories())}
  end

  def handle_event("save_container", _, socket) do
    form = socket.assigns.container_form

    case Containers.create_container(%{name: form["name"]}) do
      {:ok, _container} ->
        {:noreply,
         socket
         |> assign(:containers, Containers.list_containers())
         |> assign(:show_container_form, false)
         |> assign_new_container_form()}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_event("delete_container", %{"id" => id}, socket) do
    container = Containers.get_container!(String.to_integer(id))
    {:ok, _} = Containers.delete_container(container)

    {:noreply, assign(socket, :containers, Containers.list_containers())}
  end

  def handle_event("search", %{"query" => query}, socket) do
    items = filter_items(socket.assigns.all_items, query, socket.assigns.filter_category)

    {:noreply,
     socket
     |> assign(:search_query, query)
     |> assign(:items, items)}
  end

  defp filter_items(items, query, category_id) do
    items
    |> filter_by_search(query)
    |> filter_by_category(category_id)
  end

  defp filter_by_search(items, ""), do: items
  defp filter_by_search(items, query) do
    query = String.downcase(query)
    Enum.filter(items, fn item ->
      String.contains?(String.downcase(item.name || ""), query) ||
        String.contains?(String.downcase(item.notes || ""), query)
    end)
  end

  defp filter_by_category(items, nil), do: items
  defp filter_by_category(items, ""), do: items
  defp filter_by_category(items, category_id) do
    category_id = if is_binary(category_id), do: String.to_integer(category_id), else: category_id
    Enum.filter(items, fn item -> item.category_id == category_id end)
  end

  def handle_event("filter_category", params, socket) do
    category_id = params["category_id"] || ""
    items = filter_items(socket.assigns.all_items, socket.assigns.search_query, category_id)

    {:noreply,
     socket
     |> assign(:filter_category, category_id)
     |> assign(:items, items)}
  end

  defp parse_int(""), do: nil
  defp parse_int(nil), do: nil
  defp parse_int(str) when is_binary(str), do: String.to_integer(str)
  defp parse_int(num), do: num

  defp parse_decimal(""), do: nil
  defp parse_decimal(nil), do: nil

  defp parse_decimal(str) when is_binary(str) do
    case Decimal.parse(str) do
      {decimal, _} -> decimal
      :error -> nil
    end
  end

  defp parse_decimal(num), do: num

  @impl true
  def render(assigns) do
    ~H"""
    <div style="max-width: 900px; margin: 0 auto; padding: 20px; font-family: sans-serif;">
      <h1>Home Tracker</h1>

      <div style="margin-bottom: 20px;">
        <form phx-change="search" style="display: inline;">
          <input
            type="text"
            name="query"
            placeholder="Search items..."
            value={@search_query}
            phx-debounce="300"
            style="padding: 8px; width: 200px; margin-right: 10px;"
          />
        </form>

        <select phx-change="filter_category" name="category_id" style="padding: 8px;">
          <option value="">All Categories</option>
          <%= for cat <- @categories do %>
            <option value={cat.id} selected={@filter_category == to_string(cat.id)}>
              {cat.name}
            </option>
          <% end %>
        </select>
      </div>

      <div style="display: flex; gap: 20px;">
        <div style="flex: 2;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <h2>Items</h2>
            <button phx-click="toggle_item_form" style="padding: 8px 16px;">
              {if @show_item_form, do: "Cancel", else: "Add Item"}
            </button>
          </div>

          <%= if @show_item_form do %>
            <div style="border: 1px solid #ccc; padding: 15px; margin-bottom: 15px;">
              <h3>{if @editing_item, do: "Edit Item", else: "New Item"}</h3>
              <form phx-submit="save_item" style="display: flex; flex-direction: column; gap: 10px;">
                <input
                  type="text"
                  name="name"
                  placeholder="Name"
                  value={@item_form["name"]}
                  style="padding: 8px;"
                />
                <select name="category_id" style="padding: 8px;">
                  <option value="">Select Category</option>
                  <%= for cat <- @categories do %>
                    <option value={cat.id} selected={@item_form["category_id"] == to_string(cat.id)}>
                      {cat.name}
                    </option>
                  <% end %>
                </select>
                <select name="container_id" style="padding: 8px;">
                  <option value="">Select Container</option>
                  <%= for container <- @containers do %>
                    <option value={container.id} selected={@item_form["container_id"] == to_string(container.id)}>
                      {container.name}
                    </option>
                  <% end %>
                </select>
                <input
                  type="number"
                  name="purchase_price"
                  placeholder="Price"
                  value={@item_form["purchase_price"]}
                  step="0.01"
                  style="padding: 8px;"
                />
                <input
                  type="number"
                  name="quantity"
                  placeholder="Quantity"
                  value={@item_form["quantity"]}
                  min="1"
                  style="padding: 8px;"
                />
                <textarea
                  name="notes"
                  placeholder="Notes"
                  style="padding: 8px;"
                >{@item_form["notes"]}</textarea>
                <input
                  type="url"
                  name="photo_url"
                  placeholder="Photo URL"
                  value={@item_form["photo_url"]}
                  style="padding: 8px;"
                />
                <input
                  type="url"
                  name="receipt_url"
                  placeholder="Receipt URL"
                  value={@item_form["receipt_url"]}
                  style="padding: 8px;"
                />
                <button type="submit" style="padding: 8px 16px;">Save</button>
              </form>
            </div>
          <% end %>

          <table style="width: 100%; border-collapse: collapse;">
            <thead>
              <tr style="border-bottom: 2px solid #333;">
                <th style="text-align: left; padding: 8px;">Name</th>
                <th style="text-align: left; padding: 8px;">Category</th>
                <th style="text-align: left; padding: 8px;">Container</th>
                <th style="text-align: right; padding: 8px;">Price</th>
                <th style="text-align: right; padding: 8px;">Qty</th>
                <th style="text-align: center; padding: 8px;">Photo</th>
                <th style="text-align: center; padding: 8px;">Receipt</th>
                <th style="text-align: right; padding: 8px;">Actions</th>
              </tr>
            </thead>
            <tbody>
              <%= for item <- @items do %>
                <tr style="border-bottom: 1px solid #ddd;">
                  <td style="padding: 8px;">{item.name}</td>
                  <td style="padding: 8px;">{item.category && item.category.name}</td>
                  <td style="padding: 8px;">{item.container && item.container.name}</td>
                  <td style="text-align: right; padding: 8px;">
                    {item.purchase_price && "#{item.purchase_price}"}
                  </td>
                  <td style="text-align: right; padding: 8px;">{item.quantity}</td>
                  <td style="text-align: center; padding: 8px;">
                    <%= if item.photo_url && item.photo_url != "" do %>
                      <.link href={item.photo_url} target="_blank" rel="noopener noreferrer">View</.link>
                    <% end %>
                  </td>
                  <td style="text-align: center; padding: 8px;">
                    <%= if item.receipt_url && item.receipt_url != "" do %>
                      <.link href={item.receipt_url} target="_blank" rel="noopener noreferrer">View</.link>
                    <% end %>
                  </td>
                  <td style="text-align: right; padding: 8px;">
                    <button phx-click="edit_item" phx-value-id={item.id}>Edit</button>
                    <button phx-click="delete_item" phx-value-id={item.id}>Delete</button>
                  </td>
                </tr>
              <% end %>
            </tbody>
          </table>

          <%= if @items == [] do %>
            <p style="color: #666; text-align: center; padding: 20px;">No items found</p>
          <% end %>
        </div>

        <div style="flex: 1;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <h2>Categories</h2>
            <button phx-click="toggle_category_form" style="padding: 8px 16px;">
              {if @show_category_form, do: "Cancel", else: "Add"}
            </button>
          </div>

          <%= if @show_category_form do %>
            <div style="border: 1px solid #ccc; padding: 15px; margin-bottom: 15px;">
              <h3>New Category</h3>
              <input
                type="text"
                placeholder="Category name"
                value={@category_form["name"]}
                phx-keyup="update_category_form"
                phx-value-field="name"
                style="padding: 8px; width: 100%; margin-bottom: 10px;"
              />
              <button phx-click="save_category" style="padding: 8px 16px;">Save</button>
            </div>
          <% end %>

          <ul style="list-style: none; padding: 0;">
            <%= for cat <- @categories do %>
              <li style="display: flex; justify-content: space-between; padding: 8px; border-bottom: 1px solid #ddd;">
                <span>{cat.name}</span>
                <button phx-click="delete_category" phx-value-id={cat.id}>X</button>
              </li>
            <% end %>
          </ul>

          <%= if @categories == [] do %>
            <p style="color: #666; text-align: center;">No categories</p>
          <% end %>

          <div style="margin-top: 30px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
              <h2>Containers</h2>
              <button phx-click="toggle_container_form" style="padding: 8px 16px;">
                {if @show_container_form, do: "Cancel", else: "Add"}
              </button>
            </div>

            <%= if @show_container_form do %>
              <div style="border: 1px solid #ccc; padding: 15px; margin-bottom: 15px;">
                <h3>New Container</h3>
                <input
                  type="text"
                  placeholder="Container name"
                  value={@container_form["name"]}
                  phx-keyup="update_container_form"
                  phx-value-field="name"
                  style="padding: 8px; width: 100%; margin-bottom: 10px;"
                />
                <button phx-click="save_container" style="padding: 8px 16px;">Save</button>
              </div>
            <% end %>

            <ul style="list-style: none; padding: 0;">
              <%= for container <- @containers do %>
                <li style="display: flex; justify-content: space-between; padding: 8px; border-bottom: 1px solid #ddd;">
                  <span>{container.name}</span>
                  <button phx-click="delete_container" phx-value-id={container.id}>X</button>
                </li>
              <% end %>
            </ul>

            <%= if @containers == [] do %>
              <p style="color: #666; text-align: center;">No containers</p>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
