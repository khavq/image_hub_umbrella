defmodule ImageHubWeb.AnnotationView do
  use ImageHubWeb, :view

  def render("annotation.json", %{annotation: annotation}) do
    %{
      id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: render_one(annotation.user, ImageHubWeb.UserView, "user.json")
    }
  end
end
