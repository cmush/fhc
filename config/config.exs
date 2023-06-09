import Config

config :fhc,
  base_url: System.get_env("BASE_URL") || "http://localhost:4000",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "25")

config :logger, level: String.to_existing_atom(System.get_env("LOG_LEVEL") || "error")
