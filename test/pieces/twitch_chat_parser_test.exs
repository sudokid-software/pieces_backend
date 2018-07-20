defmodule Pieces.TwitchChatParserTests do
  use ExUnit.Case

  test "parses to map" do
    test_string = "@badges=moderator/1,turbo/1;color=#43C2FF;display-name=Ceaser_Gaming;emotes=;id=af639f90-1272-4d9e-b04b-ad5b66c8dad1;mod=1;room-id=44145819;subscriber=0;tmi-sent-ts=1530843386480;turbo=1;user-id=182190415;user-type=mod :ceaser_gaming!ceaser_gaming@ceaser_gaming.tmi.twitch.tv PRIVMSG #sudokid :You forgot the parse is what he means"

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
    assert parsed_msg == Pieces.TwitchChatParser.parse_msg(test_string, %{})
  end

  test "parses to map with emote" do
    test_string = "@badges=moderator/1,subscriber/0,bits/1000;color=#B2226A;display-name=Staghouse;emotes=88:7-14;id=f6bc91bc-5cb4-461e-b9ba-66c3e1c7e7b9;mod=1;room-id=44145819;subscriber=1;tmi-sent-ts=1530851217322;turbo=0;user-id=148530226;user-type=mod :staghouse!staghouse@staghouse.tmi.twitch.tv PRIVMSG #sudokid :@Ivena PogChamp"

    parsed_msg = {:ok, %{
      "badges" => "moderator/1,subscriber/0,bits/1000",
      "color" => "#B2226A",
      "display-name" => "Staghouse", # The Stagshagger
      "emotes" => "88:7-14",
      "id" => "f6bc91bc-5cb4-461e-b9ba-66c3e1c7e7b9",
      "mod" => "1",
      "room-id" => "44145819",
      "subscriber" => "1",
      "tmi-sent-ts" => "1530851217322",
      "turbo" => "0",
      "user-id" => "148530226",
      "user-type" => "mod",
      "room" => "sudokid",
      "msg" => "@Ivena PogChamp"
    }}
    assert parsed_msg == Pieces.TwitchChatParser.parse_msg(test_string, %{})
  end

  test "parses to map with bits" do
    test_string = "@badges=premium/1;bits=69;color=#EC4131;display-name=unicorn_dev;emotes=41:11-18;id=048035c9-4f25-4841-9181-08bc2d4d5147;mod=0;room-id=44145819;subscriber=0;tmi-sent-ts=1530851278306;turbo=0;user-id=95663717;user-type= :unicorn_dev!unicorn_dev@unicorn_dev.tmi.twitch.tv PRIVMSG #sudokid :ripcheer69 Kreygasm"

    parsed_msg = {:ok, %{
      "badges" => "premium/1",
      "color" => "#EC4131",
      "display-name" => "unicorn_dev",
      "emotes" => "41:11-18",
      "id" => "048035c9-4f25-4841-9181-08bc2d4d5147",
      "mod" => "0",
      "room-id" => "44145819",
      "subscriber" => "0",
      "tmi-sent-ts" => "1530851278306",
      "turbo" => "0",
      "user-id" => "95663717",
      "user-type" => "",
      "room" => "sudokid",
      "msg" => "ripcheer69 Kreygasm",
      "bits" => "69"
    }}
    assert parsed_msg == Pieces.TwitchChatParser.parse_msg(test_string, %{})
  end
end
