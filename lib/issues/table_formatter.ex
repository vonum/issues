defmodule Issues.TableFormatter do
  def print_table_for_columns(rows, headers) do
    data_by_columns = split_into_columns(rows, headers)
    column_widths = widths_of(data_by_columns)
    format = format_for(column_widths)

    puts_one_line_in_columns(format, headers)
    separator(column_widths) |> IO.puts
    puts_in_columns(format, data_by_columns)
  end

  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: row[header] |> printable
    end
  end

  def printable(text) when is_binary(text), do: text
  def printable(text), do: to_string(text)

  def widths_of(columns) do
    for column <- columns, do: Enum.map(column, &String.length/1) |> Enum.max
  end

  def format_for(column_widhts) do
    Enum.map_join(column_widhts, " | ", fn
      width -> "~-#{width}s"
    end) <> "~n"
  end

  def separator(column_widths) do
    Enum.map_join(column_widths, "-+-", fn
      width -> List.duplicate("-", width)
    end)
  end

  def puts_in_columns(format, data_by_columns) do
    data_by_columns
      |> List.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.each(&puts_one_line_in_columns(format, &1))
  end

  def puts_one_line_in_columns(format, fields) do
    :io.format(format, fields)
  end
end
