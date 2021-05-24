defmodule TictactoeWeb.FallbackController do
  use TictactoeWeb, :controller

  def call(conn, {:error, :invalid_player}) do
    conn
    |> put_status(500)
    |> json(%{error: "Invalid player passed !!"})
  end
end
