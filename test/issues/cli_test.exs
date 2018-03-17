defmodule Issues.CLITest do
  use ExUnit.Case

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
end
