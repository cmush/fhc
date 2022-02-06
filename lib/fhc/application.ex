defmodule Fhc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Fhc.EnvVars

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Fhc.Worker.start_link(arg)
      # {Fhc.Worker, arg}
      Fhc.HttpClient.child_spec(%{
        base_url: EnvVars.base_url(),
        pool_size: EnvVars.pool_size()
      })
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fhc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
