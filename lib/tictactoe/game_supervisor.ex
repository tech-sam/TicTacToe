defmodule Tictactoe.GameSupervisor do

  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def supervise_game_processor(game_process_name) do
    {:ok, _pid} =
      DynamicSupervisor.start_child(
        Tictactoe.GameSupervisor,
        {Tictactoe.GameProcessor, %{name: game_process_name}}
      )
  end



end
