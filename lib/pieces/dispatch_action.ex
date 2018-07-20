defmodule Pieces.DispatchAction do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: Pieces.DispatchAction)
  end

  def init(_opts \\ %{}) do
    {:ok, []}
  end

  def dispatch([h|t], command, args) do
    name = String.to_existing_atom("Elixir.#{Map.get(h, "name")}")
    case Map.get(h, "async") do
      :true ->
        appy(name, :cast, [{Map.get(h, "args"), args}])
      :false ->
        appy(name, :call, [{Map.get(h, "args"), args}])
      _ ->
        :ok
  end

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def handle_cast({:dispatch, command}, state) do
    # Cast to head with tail
    response = %{
      "name" => "Thanos Snap",
      "command" => "thanos_snap",
      "args" =>  %{  
        "required" => [  
          {"room", "sudokid"}
        ],
        "optional" => []
      },
      "description" => "Checks if you died when Thanos snapped his fingers",
      "actions" => [  
        %{  
          "name" => "Pieces.RandMsg",
          "args" => [
            "You where spared by Thanos. {{user}}",
            "You where slain by Thanos, for the good of the Universe. {{user}}"
          ],
          "async" => :false
        },
        %{
          "name" => "Pices.TwitchChatWorker",
          "args" => %{
            "send_msg" => "t_msg",  ## Will need to be set based on incomming message
            "room" => "sudokid",  ## The room the message will go back to
          }
          "async" => :false
        }
      ],
      "created" => "TIME_STAMP_HERE"
    }
    
    Map.get(response, "actions")
      |> dispatch(response)
    {:noreply, state}
  end

  def handle_cast(_, state) do
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    {:ok}
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end
end
