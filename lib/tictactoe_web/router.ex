defmodule TictactoeWeb.Router do
  use TictactoeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TictactoeWeb do
    pipe_through :api
  end

  scope "/api/v1/game", TictactoeWeb do
    pipe_through :api
    post "/create", GameController, :create_game
    post "/move", GameController, :game_move

  end

  scope "/api/v1/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :tictactoe, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "TicTacToe GameProcessor"
      },
      basePath: "/api/v1/game",
      description: "API Documentation for TicTacToe v1",
      termsOfService: "Assignment for Unchain",
      contact: %{
        name: "Sumit",
        email: "sumit.s7325@gmail.com"
      }
    }
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TictactoeWeb.Telemetry
    end
  end
end
