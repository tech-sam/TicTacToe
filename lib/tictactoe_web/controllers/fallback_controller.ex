defmodule TictactoeWeb.FallbackController do
  use TictactoeWeb, :controller

  def call(conn, {:error, :invalid_player}) do
    conn
    |> put_status(500)
    |> json(%{error: "Invalid player passed !!"})
  end

  def call(conn, {:error, :invalid_square}) do
    conn
    |> put_status(500)
    |> json(%{error: "Invalid cell cordinates, please verify row or column !!"})
  end

  def call(conn, {:error, :occupied}) do
    conn
    |> put_status(500)
    |> json(%{error: "Invalid move, cell is already occupied !!"})
  end

  def call(conn, {:error, :invalid_process}) do
    conn
    |> put_status(500)
    |> json(%{error: "Invalid gameId or game state !!"})
  end

  def call(conn, {:error, :invalid_player_turn}) do
    conn
    |> put_status(500)
    |> json(%{error: "Invalid player turn !!"})
  end

end
