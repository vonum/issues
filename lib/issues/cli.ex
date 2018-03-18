defmodule Issues.CLI do
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

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
      |> decode_response
      |> convert_to_list_of_hashdicts
      |> sort
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, text = "Resource not found"}), do: text

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    "Error fetching from github: #{message}"
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
