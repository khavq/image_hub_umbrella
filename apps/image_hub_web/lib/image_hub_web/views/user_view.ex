defmodule ImageHubWeb.UserView do
  use ImageHubWeb, :view

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.name}
  end
end
