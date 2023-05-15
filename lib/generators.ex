defmodule Obfuscate.Encoding do
  @moduledoc false
  use Rustler, otp_app: :obfuscate, crate: "generator"

  def ntsu_id(_bytes \\ 8), do: :erlang.nif_error(:nif_not_loaded)
  def owo_id(_bytes \\ 8), do: :erlang.nif_error(:nif_not_loaded)
end
