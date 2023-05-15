defmodule Obfuscate.Common do
  @moduledoc """
  Common functions in use by Obfuscate
  """

  import Obfuscate.Encoding

  # An over simplified version of checking if a URL is valid.
  @spec is_url?(String.t()) :: boolean()
  def is_url?(url) do
    url |> String.starts_with?("http://") || url |> String.starts_with?("https://")
  end

  ## Aliases
  @spec id_generator(String.t(), integer()) :: String.t()
  def id_generator("owo", bytes), do: owo_id(bytes)

  @spec id_generator(String.t(), integer()) :: String.t()
  def id_generator("ntsu", bytes), do: ntsu_id(bytes)
end
