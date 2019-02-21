defmodule PairmotronBot.Repo do
  use Ecto.Repo,
    otp_app: :pairmotron_bot,
    adapter: Ecto.Adapters.Postgres
end
