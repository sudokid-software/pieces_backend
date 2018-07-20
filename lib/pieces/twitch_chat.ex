defmodule Pieces.TwitchChat do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: Pices.TwitchChatWorker)
  end

  def init(_opts \\ %{}) do
    # os:getenv
    # {:ok, Map.merge(opts, %{twitch_oaut: System.get_env("TWITCH_OAUTH")})}
    {:ok, %{}}
  end

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def handle_cast({:connect, oauth, nick}, %{}) do
    {:ok, socket} = :ssl.connect('irc.chat.twitch.tv', 443, [])
    :ok = :ssl.send(socket, 'PASS ' ++  oauth ++ '\r\n')
    :ok = :ssl.send(socket, 'NICK ' ++ nick ++ '\r\n')
    :ok = :ssl.send(socket, 'CAP REQ :twitch.tv/membership\r\n')
    :ok = :ssl.send(socket, 'CAP REQ :twitch.tv/commands\r\n')
    :ok = :ssl.send(socket, 'CAP REQ :twitch.tv/tags\r\n')
    {:noreply, %{socket: socket, channels: []}}
  end

  def handle_cast({:join, channel}, %{socket: socket, channels: channels}=state) do
    :ok = :ssl.send(socket, 'JOIN #' ++ channel ++ '\r\n')
    {:noreply, Map.merge(state, %{channels: List ++ [channel]})}
  end

  def handle_cast({:send, msg, channel}, %{socket: socket}=state) do
    :ok = :ssl.send(socket, 'PRIVMSG #' ++ channel ++ ':' ++ msg ++ '\r\n')
    {:noreply, state}
  end

  def handle_cast({:parse, msg}, %{socket: socket}=state) do
    GenServer.cast({}, Pices.TwitchChatParser)
    {:noreply, state}
  end

  def handle_cast(_info, state) do
    {:noreply, state}
  end

  def handle_info({:ssl, _, msg}, %{socket: socket}=state) when msg == "PING :tmi.twitch.tv\r\n" do
    ## io:format("HandleInfo: Msg: ~ts", [Msg])
    :ssl.send(socket, 'PONG :tmi.twitch.tv\r\n')
    {:noreply, state}
  end

  # Data coming in is list
  def handle_info({:ssl, _, msg}, %{socket: _socket}=state) do
    IO.puts msg
    GenServer.cast({:parse, msg}, Pices.TwitchChatParserWorker)
    {:noreply, state}
  end

  def terminate(_reason, %{socket: socket}=_state) do
    :ok = :ssl.send(socket, "PART #sudokid")
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end
end
