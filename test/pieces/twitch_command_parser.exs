defmodule Pieces.CommandParserTests do
  use ExUnit.Case

  test "parses to map" do
    parsed_msg = {:ok, %{
      "badges" => "moderator/1,turbo/1",
      "color" => "#43C2FF",
      "display-name" => "Ceaser_Gaming",
      "emotes" => "",
      "id" => "af639f90-1272-4d9e-b04b-ad5b66c8dad1",
      "mod" => "1",
      "room-id" => "44145819",
      "subscriber" => "0",
      "tmi-sent-ts" => "1530843386480",
      "turbo" => "1",
      "user-id" => "182190415",
      "user-type" => "mod",
      "room" => "sudokid",
      "msg" => "You forgot the parse is what he means"
    }}


    handle_cast({:parse, data}, state) do
  end
end
