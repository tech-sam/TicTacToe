defmodule Tictactoe.GameProcessor do
  use GenServer

  alias Tictactoe.GameProcessor.GameIdGenerator, as: GameIdGenerator
  alias Tictactoe.{GameSupervisor, State, Store, Board, GameUtils}
  @board_range 1..3

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: via_tuple(opts.name))
  end

  def start(server, state) do
    GenServer.call(server, {:start, state})
  end

  def move(server, state, game_params) do
    GenServer.call(server, {:move, state, game_params})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:start, %State{status: :initial} = game_state}, _from, _state) do
    Store.new()
    |> Store.store_game(game_state)

    {:reply, {:ok, game_state.game_id}, game_state}
  end

  @impl true
  def handle_call({:move, %State{status: :initial} = game_state, game_params}, _from, _state) do
    with {:ok, player} <- GameUtils.get_player(game_params),
         {:ok, game_state} <- State.move(game_state, {:choose_p1, player}) do
      handle_call(game_state, game_params)
    else
      {:error, :invalid_player} -> {:reply, {:error, :invalid_player}, game_state}
    end
  end

  @impl true
  def handle_call({:move, %State{status: :playing} = game_state, game_params}, _from, _state) do
    handle_call(game_state, game_params)
  end

  @impl true
  def handle_call({:move, %State{status: :game_over} = game_state, _game_params}, _from, _state) do
    {:reply, {:ok, GameUtils.game_over_msg(game_state)}, game_state}
  end

  def handle_call(game_state, game_params) do
    case handle(game_state, game_params) do
      {:ok, game_state} -> {:reply, {:ok, GameUtils.build_response(game_state)}, game_state}
      {:game_over, game_state} -> {:reply, {:ok, GameUtils.game_over_msg(game_state)}, game_state}
      {:error, :invalid_player} -> {:reply, {:error, :invalid_player}, game_state}
      {:error, :invalid_square} -> {:reply, {:error, :invalid_square}, game_state}
      {:error, :occupied} -> {:reply, {:error, :occupied}, game_state}
      {:error, :invalid_player_turn} -> {:reply, {:error, :invalid_player_turn}, game_state}
      _ -> {:error, :invalid_move}
    end
  end

  def create_game() do
    with {:ok, game_id} <- GameIdGenerator.new_game_id(),
         {:ok, _pid} <- GameSupervisor.supervise_game_processor(game_id),
         {:ok, state} <- State.new(game_id),
         do: start(via_tuple(game_id), state),
         else: (error -> error)
  end

  def move_game(game_params) do
    try do
      with game_process <- via_tuple(game_params["game_id"]),
           state <- :sys.get_state(game_process),
           do: move(game_process, state, game_params)
    catch
      :exit, {:noproc, _} -> {:error, :invalid_process}
    end
  end

  def handle(%State{status: :playing} = game, game_params) do
    with {col, row} <- GameUtils.get_cell_coordinates(game_params),
         {:ok, player} <- validate_player_turn(game, game_params),
         {:ok, board} <- play_at(game.board, col, row, game.turn),
         {:ok, game} <- State.move(%{game | board: board}, {:play, game.turn}),
         won? <- win_check(board, player),
         {:ok, game} <- State.move(game, {:check_for_winner, won?}),
         over? <- game_over?(game),
         {:ok, game} <- State.move(game, {:game_over?, over?})
         do
          case game do
            %State{status: :game_over} -> {:game_over, game}
            _ -> {:ok, game}
          end

         end

         # here handle a win event
  end

  def check_player(player) do
    case player do
      :x -> {:ok, player}
      :o -> {:ok, player}
      _ -> {:error, :invalid_player}
    end
  end

  def validate_player_turn(game, params) do
    current_player = String.to_atom(params["player"])

    case game.validate_player_turn && current_player != game.turn do
      true -> {:error, :invalid_player_turn}
      false -> {:ok, game.turn}
    end
  end

  def play_at(board, col, row, player) do
    with {:ok, valid_player} <- check_player(player),
         {:ok, square} <- Board.new(col, row),
         {:ok, new_board} <- place_piece(board, square, valid_player),
         do: {:ok, new_board}
  end

  def place_piece(board, place, player) do
    case board[place] do
      nil -> {:error, :invalid_location}
      :x -> {:error, :occupied}
      :o -> {:error, :occupied}
      :empty -> {:ok, %{board | place => player}}
    end
  end

  def win_check(board, player) do
    cols = Enum.map(@board_range, &Board.get_board_col(board, &1))
    rows = Enum.map(@board_range, &Board.get_board_rows(board, &1))
    diagonals = Board.get_board_diagonals(board)
    win? = Enum.any?(cols ++ rows ++ diagonals, &won_line(&1, player))
    if win?, do: player, else: false
  end

  def game_over?(game) do
    board_full = Enum.all?(game.board, fn {_, v} -> v != :empty end)

    if board_full or game.winner do
      :game_over
    else
      :not_over
    end
  end

  def won_line(line, player), do: Enum.all?(line, &(player == &1))



  def build_board_response(board) do
    Board.build_board_response(board)
  end

  defp via_tuple(name) do
    {:via, Registry, {Tictactoe.GameRegistry, name}}
  end
end
