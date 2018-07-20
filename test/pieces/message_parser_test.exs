defmodule Pieces.CommandParserTests do
  use ExUnit.Case

  test "parses msg to map" do
    test_string = ["!test", "hello", "world"]

    parsed_msg = {:ok, %{command: "test", args: ["hello", "world"]}}
    assert parsed_msg == Pieces.CommandParser.parse_msg(test_string, %{})
  end
end
