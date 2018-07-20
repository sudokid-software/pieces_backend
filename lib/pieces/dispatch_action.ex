defmodule Pieces.DispatchAction do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: Pices.DispatchAction)
  end

  def init(_opts \\ %{}) do
    {:ok, []}
  end

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def handle_cast({:dispatch, command}, state) do
    # Cast to head with tail
    {:ok, %{
      "name" => "Thanos Snap",
      "command" => "thanos_snap",
      "args" =>  %{  
        "required" => [  
          %{"user" => 0}
        ]
      },
      "description" => "Checks if you died when Thanos snapped his fingers",
      "actions" => [  
        %{  
          "rand_msg" => [  ## Make call to random_msg sysem
            "You where spared by Thanos. {{user}}",
            "You where slain by Thanos, for the good of the Universe. {{user}}"
          ],
          "async" => :false  ## Uses GenServer.call()
        },
        %{
          "send_msg" => "t_msg",  ## Will need to be set based on incomming message
          "room" => "sudokid",  ## The room the message will go back to
          "async" => :false ## Uses GenServer.cast()
        }
      ],
      "created" => "TIME_STAMP_HERE"
    }}
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    {:ok}
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end
end
