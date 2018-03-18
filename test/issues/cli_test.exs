defmodule Issues.CLITest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "returns :help" do
    assert Issues.CLI.parse(["-h"]) == :help
    assert Issues.CLI.parse(["--help"]) == :help
  end

  test "returns user, mazesolver and default issues count" do
    assert Issues.CLI.parse(["vonum", "mazesolver"])
             == {"vonum", "mazesolver", 10}
  end

  test "returns user, mazesolver and issues count" do
    assert Issues.CLI.parse(["vonum", "mazesolver", "7"])
             == {"vonum", "mazesolver", 7}
  end

  test "prints how to use package" do
    assert capture_io(fn -> Issues.CLI.process(:help) end)
             == "usage: issues <user> <project> [count | 10]\n\n"
  end

  test "returns body" do
    assert Issues.CLI.decode_response({:ok, %{}}) == %{}
  end

  test "returns not found message" do
    assert Issues.CLI.decode_response({:error, "Resource not found"})
             == "Resource not found"
  end

  test "returns error message" do
    assert Issues.CLI.decode_response({:error, [{"message", :timeout}]})
             == "Error fetching from github: timeout"
  end

  test "converts list of lists to list of maps" do
    list_of_lists = [
      [issue: :fix_me],
      [pr: :implement_me]
    ]
    list_of_maps = [
      %{issue: :fix_me},
      %{pr: :implement_me}
    ]

    assert Issues.CLI.convert_to_list_of_hashdicts(list_of_lists)
             == list_of_maps
  end

  test "sorts by created_at" do
    list = [
      %{"created_at" => ~D[2018-07-08]},
      %{"created_at" => ~D[2018-07-07]}
    ]

    assert Issues.CLI.sort(list) == Enum.reverse(list)
  end
end
