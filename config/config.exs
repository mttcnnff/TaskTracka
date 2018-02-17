# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :tasktracka,
  ecto_repos: [Tasktracka.Repo]

# Configures the endpoint
config :tasktracka, TasktrackaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KxIiXiHzc973e5MMCfHbdcf0wZvtIjL7ijOWYpFYc2FnPw+KwH8HAiLCU7JuHte2",
  render_errors: [view: TasktrackaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tasktracka.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
