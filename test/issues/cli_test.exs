defmodule Issues.CLITest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.CLI, as: CLI

  test "returns :help" do
    assert CLI.parse(["-h"]) == :help
    assert CLI.parse(["--help"]) == :help
  end

  test "returns user, mazesolver and default issues count" do
    assert CLI.parse(["vonum", "mazesolver"])
             == {"vonum", "mazesolver", 10}
  end

  test "returns user, mazesolver and issues count" do
    assert CLI.parse(["vonum", "mazesolver", "7"])
             == {"vonum", "mazesolver", 7}
  end

  test "prints how to use package" do
    assert capture_io(fn -> CLI.process(:help) end)
             == "usage: issues <user> <project> [count | 10]\n\n"
  end

  test "returns body" do
    assert CLI.decode_response({:ok, %{}}) == %{}
  end

  test "prints error message" do
    assert CLI.decode_response({:error, "Resource not found"})
             == "Error fetching from GitHub: Resource not found"
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

    assert CLI.convert_to_list_of_hashdicts(list_of_lists)
             == list_of_maps
  end

  test "sorts by created_at" do
    list = [
      %{"created_at" => ~D[2018-07-08]},
      %{"created_at" => ~D[2018-07-07]}
    ]

    assert CLI.sort(list) == Enum.reverse(list)
  end
end
