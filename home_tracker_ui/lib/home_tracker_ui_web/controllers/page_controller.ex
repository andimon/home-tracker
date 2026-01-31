defmodule HomeTrackerUiWeb.PageController do
  use HomeTrackerUiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
