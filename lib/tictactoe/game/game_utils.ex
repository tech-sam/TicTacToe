defmodule Tictactoe.GameUtils do

  alias Tictactoe.{Board}

  def get_player(params) do
    Map.has_key?(params, "player") && {:ok, String.to_atom(String.downcase(Map.get(params, "player", "")))} || {:error, :invalid_player}
  end

  def get_cell_coordinates(params) do
    (Map.has_key?(params, "col") && Map.has_key?(params, "row")) && {Map.get(params, "col", 0) ,Map.get(params, "row", 0)} || {:error, "Invalid cell cordinates!!"}
  end

  def build_response(game) do
    %{
      game_id:  game.game_id,
      board: Board.build_board_response(game.board),
      player: game.turn,
      winner: game.winner,
    }
  end

  def game_over_msg(game) do
    case game.winner do
      :tie -> "Game is tie, time to start something new !!"
      _ ->  "Player #{Atom.to_string(game.winner)} is winner of the game !!"
    end

  end

end
