defmodule TictactoeWeb.GameController do
  use TictactoeWeb, :controller
  alias Tictactoe.GameProcessor, as: GameProcessor

  action_fallback TictactoeWeb.FallbackController




  def create_game(conn, _params) do
    with {:ok, game_id} <- GameProcessor.create_game(),
         do: json(conn, %{game_id: game_id})
  end

  def game_move(conn, %{"game_params" => params}) do
    with {:ok, game_state} <- GameProcessor.move_game(params),
         do: json(conn, game_state)
  end

end
