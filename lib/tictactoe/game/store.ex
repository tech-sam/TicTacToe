defmodule Tictactoe.Store do

  def new(), do: %{}

  def store_game(store,game)  do
    Map.put(store,game.game_id,game)
  end

  def fetch_game(store,game)  do
    Map.get(store,game.game_id,%{})
  end

end
