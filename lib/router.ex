defmodule Obfuscate.Router do
  @moduledoc false
  use Plug.Router
  import Plug.Conn

  alias Obfuscate.Common

  if Mix.env() == :dev do
    plug(Plug.Logger)
  end

  plug(:match)
  plug(:dispatch)

  @spec respond(Plug.Conn, atom(), integer(), String.t()) :: Plug.Conn
  def respond(conn, :json, code, message) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code, Jason.encode!(%{message: message}))
    |> halt()
  end

  get "/" do
    conn |> respond(:json, 200, "Welcome to Obfuscate!")
  end

  get "/obfuscate" do
    conn = conn |> fetch_query_params()

    url = conn.query_params()[:url]

    IO.puts url
  end

  get _ do
    conn |> respond(:json, 404, "Route doesn't exist...")
  end
end
