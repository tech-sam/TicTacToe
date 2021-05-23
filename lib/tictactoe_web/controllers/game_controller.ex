defmodule TictactoeWeb.GameController do
  use TictactoeWeb, :controller
  alias Tictactoe.GameProcessor, as: GameProcessor
  alias Tictactoe.State, as: State

  action_fallback TictactoeWeb.FallbackController

  def create_game(conn, _params) do
    with game_id <- GameProcessor.create_game(),
         do: json(conn, %{game_id: game_id})
  end

  def game_move(conn, %{"game_params" => params}) do
    IO.inspect("--game_move call----")
    IO.inspect(params["col"])
    {:ok, state} = State.new(params["game_id"])
    IO.inspect("map from struct")
    IO.inspect(Map.from_struct(state))
    json(conn, %{})
  end

end
