defmodule Tictactoe.State do

  alias Tictactoe.{Board, State,GameConstants,GameProcessor}


  defstruct game_id: nil,
            status: :initial,
            turn: nil,
            winner: false,
            board: Board.new_board(),
            ui: nil

  def new(game_id), do: {:ok, %State{game_id: game_id}}
  def new(ui), do: {:ok, %State{ui: ui}}

  def move(%State{status: :initial} = state, {:choose_p1, player}) do
    case GameProcessor.check_player(player) do
      {:ok, valid_player} ->
        {:ok, %State{state | status: :playing, turn: valid_player}}
      _ ->
        {:error, :invalid_player}
    end
  end



end
