defmodule Tictactoe.Square do
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_size 1..3

  def new(col, row) when col in @board_size and row in @board_size do
    {:ok, %Tictactoe.Square{col: col, row: row}}
  end

  def new(_row, _col), do: {:error, :invalid_square}

  def new_board do
    for s <- squares(), into: %{}, do: {s, :empty}
  end

  @spec squares :: any
  def squares do
    for col <- @board_size,
        row <- @board_size,
        into: MapSet.new(),
        do: %Tictactoe.Square{col: col, row: row}
  end
end
