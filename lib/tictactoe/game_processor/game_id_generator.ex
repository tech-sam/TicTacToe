defmodule Tictactoe.GameProcessor.GameIdGenerator do
  def new_game_id do
    {:ok, Ecto.UUID.generate}
  end
end
