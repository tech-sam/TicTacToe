defmodule Tictactoe.GameUtils do

  def get_player(params) do
    Map.has_key?(params, "player") && {:ok, String.to_atom(Map.get(params, "player", ""))} || {:error, :invalid_player}
  end

end
