defmodule Pieces.CommandParser do
  use GenServer

  def parser({:twitch, msg}) do
    GenServer.cast(__MODULE__, {:parse, msg})
  end

  def parser(msg) do
    # GenServer.cast(__MODULE__, {:parse, msg})
    ok:
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: Pices.MessageParser)
  end

  def init(_opts \\ %{}) do
    {:ok, []}
  end

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def handle_cast({:parse, data}, state) do
    case Map.fetch("msg") do
      {:ok, msg} ->
        msg
        |> List.to_string()
        |> String.trim()
        |> String.split(" ", trim: true)
        |> parse_msg(%{})
        |> dispatch_actions(data)
        {:noreply, state}
      :error ->
        {:noreply, state}
    end
  end

  def parse_msg(["!" <> command|args], parsed_msg) do
    {:ok, %{command: command, args: args}}
  end

  def parse_msg(msg, parsed_msg) do
    {:pass, parsed_msg}
  end

  def get_command(

  def dispatch_actions({:ok, %{command: command, args: args}}, data) do
    IO.puts "Command: #{inspect(command)}, Args: #{inspect(args)}"
    # This call will return an object from the DB
    {:ok, %{
      "name" => "Thanos Snap",
      "command" => "thanos_snap",
      "args" =>  %{  ## Tobe added
        "required" => [  
          %{"user" => "ws_ubi"}  ## User used in message
        ]
      },
      "info" => %{
        "room" => "sudokid",  # not an arg
        "user" => "sudokid",  # The user that sent the message
      },
      "description" => "Checks if you died when Thanos snapped his fingers",
      "actions" => %{
        "list" => [
          %{
            "name" => "rand_msg",
            "rand_msg" => [  ## Make call to random_msg sysem
              "You where spared by Thanos. {{user}}",
              "You where slain by Thanos, for the good of the Universe. {{user}}"
            ],
            "args" => %{
              "required" => [
                "user"
              ]
            },
            "async" => :false  ## Uses RandMsg.call() // RandMsg.cast()
          },  ## Removed after RandMsg.call()
          %{
            "name" => "t_send_msg",
            "async" => :true ## Uses GenServer.cast()
          }
        ],
        "args" =>  %{  
          "required" => [  
            "user"
          ]
        },
      },
      "created" => "TIME_STAMP_HERE"
    }}  ## Loop over actions
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
