defmodule ImageHubWeb.Channels.UserSocketTest do
  use ImageHubWeb.ChannelCase, async: true
  alias ImageHubWeb.UserSocket

  test "socket authentication with valid token" do
    token = Phoenix.Token.sign(@endpoint, "user socket", "123")

    assert {:ok, socket} = connect(UserSocket, %{"token" => token}, [])
    assert socket.assigns.current_user == "123"
  end

  test "socket authentication with invalid token" do
    assert :error = connect(UserSocket, %{"token" => "1313"}, [])
    assert :error = connect(UserSocket, %{"token" => ""}, [])
  end
end
