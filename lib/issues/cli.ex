defmodule Issues.CLI do
  @default_count 10

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
end
