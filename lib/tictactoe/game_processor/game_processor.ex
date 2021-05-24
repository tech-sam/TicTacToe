defmodule Tictactoe.GameProcessor do
  use GenServer

  alias Tictactoe.GameProcessor.GameIdGenerator, as: GameIdGenerator
  alias Tictactoe.{GameSupervisor,State,Store,Board,GameUtils}


  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: via_tuple(opts.name))
  end

  def start(server, state) do
    GenServer.call(server, {:start, state})
  end

  def move(server, state, game_params) do
    GenServer.call(server, {:move, state,game_params})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:start, %State{status: :initial} = game_state}, _from, state) do
     Store.new()
    |> Store.store_game(game_state)
    {:reply, {:ok, game_state.game_id}, game_state}
  end

  @impl true
  def handle_call({:move, %State{status: :initial} = game_state,game_params}, _from, state) do
     with {:ok, player} <-  GameUtils.get_player(game_params),
    {:ok, game_state} <- State.move(game_state, {:choose_p1, player}),
    {:ok,game_state} <- handle(game_state)
    do
      {:reply, {:ok, game_state.game_id}, game_state}
    else
      {:error,:invalid_player} ->
        {:reply, {:error, :invalid_player},game_state}
        err ->
          {:error, err}
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

    with game_process <- via_tuple(game_params["game_id"]),
        state <- :sys.get_state(game_process),
    do: move(game_process,state,game_params),
    else: (error -> error)
  end

  def handle(%State{status: :playing} = game) do
    player = game.turn
    # get the col and row from here

    {:ok,game}
  end


  def check_player(player) do
    case player do
      :x -> {:ok, player}
      :o -> {:ok, player}
      _ -> {:error,:invalid_player}
    end
  end


  def build_board_response(board) do
    Board.build_board_response(board)
  end

  defp via_tuple(name) do
    {:via, Registry, {Tictactoe.GameRegistry, name}}
  end

end
