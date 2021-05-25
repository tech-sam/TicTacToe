defmodule Tictactoe.Game.Cli do

  alias Tictactoe.{State,Game,GameUtils}
  alias Tictactoe.Game.Cli, as: Cli

  def play() do
    Game.start(&Cli.handle/2)
  end

  def handle(%State{status: :initial}, :get_players) do
    IO.gets("Which player will go first x or o ?")
    |> String.trim()
    |> String.to_atom()
  end

  def handle(%State{status: :playing} = state, :request_move) do
    display_board(state.board)
    IO.puts("What's #{state.turn}'s next move ?")
    col = IO.gets("Col: ") |> trimmed_int
    row = IO.gets("Row: ") |> trimmed_int
    {col, row}
  end

  def handle(%State{status: :game_over} = state,_) do
    display_board(state.board)
    GameUtils.game_over_msg(state)
  end

  def show(board, c, r) do
    [item] = for {%{col: col, row: row}, value} <- board, col == c, row == r, do: value

    if item == :empty, do: " ", else: to_string(item)
  end

  def display_board(board) do
    IO.puts("""
    #{show(board, 1, 1)} | #{show(board, 2, 1)} | #{show(board, 3, 1)}
    ---------
    #{show(board, 1, 2)} | #{show(board, 2, 2)} | #{show(board, 3, 2)}
    ---------
    #{show(board, 1, 3)} | #{show(board, 2, 3)} | #{show(board, 3, 3)}

    """)
  end

  def trimmed_int(str) do
    str |> String.trim |> String.to_integer
  end

end
