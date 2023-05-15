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
    |> send_resp(code, Jason.encode!(%{status: code, message: message}))
    |> halt()
  end

  get "/" do
    conn |> respond(:json, 200, "Welcome to Obfuscate!")
  end

  get "/obfuscate" do
    conn = conn |> fetch_query_params()

    url = conn.query_params() |> Map.get("url")
    generator = conn.query_params() |> Map.get("gen", "owo")
    length = conn.query_params() |> Map.get("len", "8")

    if !Common.is_url?(url) do
      conn |> respond(:json, 400, "Invalid URL")
    end

    id = Common.id_generator(generator, String.to_integer(length))

    Obfuscate.InMemory.set(url, id)

    conn |> respond(:json, 201, "#{id}")
  end

  get _ do
    conn |> respond(:json, 404, "Route doesn't exist...")
  end
end
