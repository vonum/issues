defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir vonum.mk@gmail.com"}]
  @github_api_url "https://api.github.com"

  def fetch(user, project) do
    issues_url(user, project)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end

  defp issues_url(user, project) do
    "#{@github_api_url}/repos/#{user}/#{project}/issues"
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, body}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 404}}) do
    {:error, "Resource not found"}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
