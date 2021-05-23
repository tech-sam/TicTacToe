defmodule Tictactoe.GameProcessor do
  use GenServer

  alias Tictactoe.GameProcessor.GameIdGenerator, as: GameIdGenerator
  alias Tictactoe.GameSupervisor, as: GameSupervisor
  alias Tictactoe.State, as: State
  alias Tictactoe.Store, as: GameStore

  def create_game() do
    with {:ok, game_id} <- GameIdGenerator.new_game_id(),
         {:ok, _pid} <- GameSupervisor.supervise_game_processor(game_id),
         {:ok, state} <- State.new(game_id),
          do: start(via_tuple(game_id), state),

         else: (error -> error)
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: via_tuple(opts.name))
  end

  def start(server, state) do
    GenServer.call(server, {:start, state})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:start, %State{status: :initial} = game_state}, _from, state) do
     GameStore.new()
    |> GameStore.store_game(game_state)
    {:reply, game_state.game_id, game_state}
  end

  def via_tuple(name) do
    {:via, Registry, {Tictactoe.GameRegistry, name}}
  end

end
