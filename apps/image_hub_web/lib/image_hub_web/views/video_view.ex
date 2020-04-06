defmodule ImageHubWeb.VideoView do
  use ImageHubWeb, :view
  alias ImageHub.Multimedia

  def category_select_options(categories) do
    for category <- categories, do: {category.name, category.id}
  end
end
