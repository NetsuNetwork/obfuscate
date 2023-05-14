defmodule Obfuscate.Encoding do
  @moduledoc false
  use Rustler, otp_app: :obfuscate, crate: "encoding"

  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
end
