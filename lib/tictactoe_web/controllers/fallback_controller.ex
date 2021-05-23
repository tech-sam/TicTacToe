defmodule TictactoeWeb.FallbackController do
  use TictactoeWeb, :controller

  def call(conn, _) do
    conn
    |> put_status(500)
    |> json(%{error: "its not you its us !!"})
  end
end
