defmodule Produto.Repo do
  use Ecto.Repo,
    otp_app: :produto,
    adapter: Ecto.Adapters.SQLite3
end
