defmodule Pieces.RandMsg do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: Pices.RandMsg)
  end

  def init(_opts \\ %{}) do
    {:ok, []}
  end

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def handle_cast({:parse, data}, state) do
    {:noreply, state}
  end

  def parse_msg(["!" <> command|args], parsed_msg) do
    {:ok, %{command: command, args: args}}
  end

  def parse_msg(msg, parsed_msg) do
    {:pass, parsed_msg}
  end

  def dispatch(_not_command) do
    :error
  end

  def dispatch() do
    {:ok}
  end

  def terminate(_reason, _state) do
    {:ok}
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end
end
