defmodule Pieces.RandMsg do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: Pices.RandMsg)
  end

  def init(_opts \\ %{}) do
    {:ok, []}
  end

  def cast(args) do
    GenServer.cast(self(), args)
  end

  def call(args) do
    GenServer.call(self(), args)
  end

  def handle_call({args, %{"required" => required, "optional" => optional}}, _from, state) do
    {:reply, {"msg", Enum.random(args)}, state}
  end

  def handle_cast({args, %{"required" => required, "optional" => optional}}, state) do
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    {:ok}
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end
end
