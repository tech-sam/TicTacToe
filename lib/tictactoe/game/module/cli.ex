defmodule Tictactoe.Game.Cli do

  alias Tictactoe.{State}

  def handle(%State{status: :initial}, :get_players) do
    IO.gets("Which player will go first x or o ?")
    |> String.trim()
    |> String.to_atom()
  end

end
