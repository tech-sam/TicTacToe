# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config
config :tictactoe,
  ecto_repos: [Tictactoe.Repo]

# Configures the endpoint
config :tictactoe, TictactoeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+/kPoj8AxR68/Rai3SYJqYZmdeYci66iBObe6C+OtKEQw7B82Oyn+9Fo5OVA6tK4",
  render_errors: [view: TictactoeWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Tictactoe.PubSub,
  live_view: [signing_salt: "fenP0M8X"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Swagger Configuration
config :tictactoe, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: TictactoeWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: TictactoeWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }
 config :phoenix_swagger, json_library: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
