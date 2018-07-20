defmodule Pieces.TwitchChatParser do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: Pices.TwitchChatParserWorker)
  end

  def init(_opts \\ %{}) do
    {:ok, []}
  end

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def handle_cast({:parse, msg}, state) do
    parsed_msg =
      msg
      |> List.to_string()
      |> parse_msg(%{})
    # Call to next step
    {:noreply, state}
  end

  def parse_msg("",  parsed_msg) do
    Pieces.CommandParser.parser(parsed_msg)
    {:ok, parsed_msg}
  end

  def parse_msg([["user-type", v], []], parsed_msg) do
    [user_type, room_data, msg] = String.split(v, ":", parts: 3)
    [_, room] = String.split(room_data, "#")
    temp_map = %{
      "user-type" => String.trim(user_type),
      "msg" => String.trim(msg),
      "room" => String.trim(room)
    }
    parse_msg("", Map.merge(parsed_msg, temp_map))
  end

  def parse_msg([["@badges", v],[msg]], parsed_msg) do
    parse_msg(msg, Map.merge(parsed_msg, %{"badges" => v}))
  end

  def parse_msg([[k, v],[msg]], parsed_msg) do
    parse_msg(msg, Map.merge(parsed_msg, %{k => v}))
  end

  def parse_msg(msg, parsed_msg) do
    [key_value|rest_of_msg] = String.split(msg, ";", parts: 2)
    [key, value] = String.split(key_value, "=")
    parse_msg([[key, value], rest_of_msg], parsed_msg)
  end

  def terminate(_reason, _state) do
    {:ok}
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end
end
