defmodule Tictactoe.State do

  alias Tictactoe.{Board,State,GameConstants,GameProcessor}
  require GameConstants

  @players GameConstants.players


  defstruct game_id: nil,
            status: :initial,
            turn: nil,
            winner: false,
            validate_player_turn: true,
            board: Board.new_board(),
            ui: nil

  def new(game_id), do: {:ok, %State{game_id: game_id}}

  def new(ui,_game_id), do: {:ok, %State{ui: ui}}

  def move(%State{status: :initial} = state, {:choose_p1, player}) do
    case GameProcessor.check_player(player) do
      {:ok, valid_player} ->
        {:ok, %State{state | status: :playing, turn: valid_player, validate_player_turn: false}}
      _ ->
        {:error, :invalid_player}
    end
  end

  def move(%State{status: :playing}, {:play, player}) when player not in @players do
    {:error, :invalid_player}
  end

  def move(%State{status: :playing, turn: player} = state, {:play, player}) do
    {:ok, %State{state | turn: other_player(player), validate_player_turn: true}}
  end

  def move(%State{status: :playing} = state, {:check_for_winner, winner}) do
    win_state = %State{state | status: :game_over, turn: nil, winner: winner}

    case winner do
      :x -> {:ok, win_state}
      :o -> {:ok, win_state}
      _ -> {:ok, state}
    end
  end

  def move(%State{status: :playing} = state, {:game_over?, over_or_not}) do
    case over_or_not do
      :not_over -> {:ok, state}
      :game_over -> {:ok, %State{state | status: :game_over, winner: :tie}}
      _ -> {:error, :invalid_game_over_status}
    end
  end

  def move(%State{status: :game_over} = state, {:game_over?, _}) do
    {:ok, state}
  end

  def move(state, action) do
    {:event, {:invalid_state_transition, %{status: state.status, action: action}}}
  end


  def other_player(player) do
    case player do
      :x -> :o
      :o -> :x
      _ -> {:error, :invalid_player}
    end
  end

end
