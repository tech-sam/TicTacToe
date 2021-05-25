defmodule Tictactoe.Game do
  alias Tictactoe.{State,GameProcessor}

  def start(ui) do
    with {:ok, game} <- State.new(ui,nil),
         player <- ui.(game, :get_players),
         {:ok, game} <- State.move(game, {:choose_p1, player}),
         do: handle(game),
         else: (error -> error)
  end


  def handle(%State{status: :playing} = game) do
    player = game.turn
    with {col, row} <- game.ui.(game, :request_move),
         {:ok, board} <- GameProcessor.play_at(game.board, col, row, game.turn),
         {:ok, game} <- State.move(%{game | board: board}, {:play, game.turn}),
         won? <- GameProcessor.win_check(board, player),
         {:ok, game} <- State.move(game, {:check_for_winner, won?}),
         over? <- GameProcessor.game_over?(game),
         {:ok, game} <- State.move(game, {:game_over?, over?}),
         do: handle(game),
         else: (error -> error)
  end

  def handle(%State{status: :game_over} = game) do
    game.ui.(game, nil)
  end

end
