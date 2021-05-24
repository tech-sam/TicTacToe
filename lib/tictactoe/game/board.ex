defmodule Tictactoe.Board do
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_size 1..3

  def new(col, row) when col in @board_size and row in @board_size do
    {:ok, %Tictactoe.Board{col: col, row: row}}
  end

  def new(_row, _col), do: {:error, :invalid_square}

  def new_board do
    for s <- squares(), into: %{}, do: {s, :empty}
  end

  def squares do
    for col <- @board_size,
        row <- @board_size,
        into: MapSet.new(),
        do: %Tictactoe.Board{col: col, row: row}
  end

  def build_board_response(board) do
    for {%{col: col, row: row}  , player} <- board, into: %{}, do: {Jason.encode!(%{col: col,row: row}), player}
  end

  def get_board_col(board, col) do
    for {%{col: c, row: _}, v} <- board, col == c, do: v
  end

  def get_board_rows(board, row) do
    for {%{col: _, row: r}, v} <- board, row == r, do: v
  end

  def get_board_diagonals(board) do
    [
      for({%{col: c, row: r}, v} <- board, c == r, do: v),
      for({%{col: c, row: r}, v} <- board, c + r == 4, do: v)
    ]
  end

end
