
> "The simpler the food, the harder it is to prepare well" - Joël Robuchon.

# Tictactoe

This is an Elixir Phoenix backend API application that provides rest endpoints to play a TicTacToe board game.
API's designed in such a way that any frontend web or mobile applications can consume them.

## Deployment

Deployment has done using one of the most popular PaaS [Heroku using the container stack](https://hexdocs.pm/phoenix/heroku.html).

> Note :  It might take up to 20 sec to get the API response first time, because Heroku unloads applications from the memory after some inactivity time. See [Dyno Sleeping](https://devcenter.heroku.com/articles/free-dyno-hours#dyno-sleeping).

### App URL
https://tictac9.herokuapp.com






In-memory state such as those in Agents, GenServers, and ETS will be lost every 24 hours.



To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
