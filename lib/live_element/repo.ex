defmodule LiveElement.Repo do
  use Ecto.Repo,
    otp_app: :live_element,
    adapter: Ecto.Adapters.Postgres
end
