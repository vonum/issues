defmodule Issues.CLI do
  alias Issues.GithubIssues, as: GithubIssues
  alias Issues.TableFormatter, as: TF

  @default_count 10

  def run(argv) do
    argv
      |> parse
      |> process
  end

  def parse(argv) do
    parsed_args = OptionParser.parse(argv,
                                     switches: [help: :boolean],
                                     aliases: [h: :help])
    case parsed_args do
      {[help: true], _, _} ->
        :help
      {_, [user, project, count], _} ->
        {user, project, String.to_integer(count)}
      {_, [user, project], _} ->
        {user, project, @default_count}
    end
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [count | #{@default_count}]
    """
  end

  def process({user, project, count}) do
    response = GithubIssues.fetch(user, project) |> decode_response

    if is_binary(response) do
      IO.puts(response)
    else
      response
        |> convert_to_list_of_hashdicts
        |> sort
        |> Enum.take(count)
        |> TF.print_table_for_columns(["number", "created_at", "title"])
    end
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    "Error fetching from GitHub: #{error}"
  end

  def convert_to_list_of_hashdicts(list) do
    list
      |> Enum.map(&Enum.into(&1, Map.new))
  end

  def sort(list) do
    list
      |> Enum.sort(fn
        (i1, i2) -> i1["created_at"] <= i2["created_at"]
      end)
  end
end
