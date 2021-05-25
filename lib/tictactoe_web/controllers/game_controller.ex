defmodule TictactoeWeb.GameController do
  use TictactoeWeb, :controller
  use PhoenixSwagger

  alias Tictactoe.GameProcessor, as: GameProcessor
  alias Tictactoe.GameProcessor.GameIdGenerator, as: GameIdGenerator

  action_fallback TictactoeWeb.FallbackController

  swagger_path :create_game do
    post("/create")
    summary "Start a game"
    description("create a unique game in UUID format")
    response 200, "Success", nil, game_id: GameIdGenerator.new_game_id
  end

  def create_game(conn, _params) do
    with {:ok, game_id} <- GameProcessor.create_game(),
         do: json(conn, %{game_id: game_id})
  end

  swagger_path :game_move do
    post "/move"
    summary "Play a move"
    description "A Game move after generating a gameId"
    produces "application/json"
    parameters do
      game_params :body, :string, "game parameters col,row,player and game_id", required: true
    end
    response 200, "Game board state, gameId and next player turn will be returned", nil, %{}
    response 500, "Invalid game move errors for different parameters"
  end
  def game_move(conn, %{"game_params" => params}) do
    with {:ok, game_state} <- GameProcessor.move_game(params),
         do: json(conn, game_state)
  end

end
