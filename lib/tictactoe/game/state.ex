defmodule Tictactoe.State do
  alias Tictactoe.{Board, State}
  @players [:x, :o]

  defstruct game_id: nil,
            status: :initial,
            turn: nil,
            winner: false,
            board: Board.new_board(),
            ui: nil

  def new(game_id), do: {:ok, %State{game_id: game_id}}
  # def new(ui), do: {:ok, %State{ui: ui}}
end
