defmodule Issues.TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  setup do
    {
      :ok,
      rows: [
        [c1: "r1 c1", c2: "r1 c2"],
        [c1: "r2 c1", c2: "r2 c2"]
      ],
      headers: [:c1, :c2]
    }
  end

  test "returns string" do
    assert TF.printable("pls") == "pls"
  end

  test "returns string representation of value" do
    assert TF.printable(:pls) == "pls"
  end

  test "returns max column width" do
    columns = [
      ["pls", "plspls"],
      ["wut", "wpls"]
    ]
    assert TF.widths_of(columns) == [6, 4]
  end

  test "formats for column widhts" do
    column_widths = [2, 3, 2, 1]
    assert TF.format_for(column_widths) ==
             "~-2s | ~-3s | ~-2s | ~-1s~n"
  end

  test "creates separator based on column widhts" do
    column_widths = [2, 3, 2, 1]
    assert TF.separator(column_widths) ==
             "---+-----+----+--"
  end

  test "splits data into columns", context do
    headers = context[:headers]
    rows = context[:rows]

    assert TF.split_into_columns(rows, headers)
             == [["r1 c1", "r2 c1"], ["r1 c2", "r2 c2"]]

  end

  test "prints correct data", context do
    headers = context[:headers]
    rows = context[:rows]

    result = capture_io fn ->
      TF.print_table_for_columns(rows, headers)
    end
    assert result == """
    c1    | c2\s\s\s
    ------+------
    r1 c1 | r1 c2
    r2 c1 | r2 c2
    """
  end
end
