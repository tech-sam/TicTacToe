
> "The simpler the food, the harder it is to prepare well" - Joël Robuchon.

# Tictactoe

Welcome to the TicTacToe Game Processor, an Elixir Phoenix API that manages a TicTacToe game, allowing any type of client and providing a common interface for them to play a game.

## Main Technology stack

*  [Elixir](https://elixir-lang.org/)
*  [Phoenix](https://www.phoenixframework.org/)

## Deployment

Deployment has done using one of the most popular PaaS [Heroku using the container stack](https://hexdocs.pm/phoenix/heroku.html).

> Note :  It might take up to 20 sec to get the API response first time, because Heroku unloads applications from the memory after some inactivity time and In-memory state such as those in Agents, GenServers, and ETS will be lost every 24 hours means a started game if not completed within 24 hours will be vanished.
See [Dyno Sleeping](https://devcenter.heroku.com/articles/free-dyno-hours#dyno-sleeping).

### App URL
https://tictac9.herokuapp.com

## Getting up and running:

#### To start application as a local Phoenix server:

  * Install Elixir from the [Elixir downloads page](https://elixir-lang.org/install.html).
  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`
  * The game processor should be accessible now in `localhost:4000`.
  * Currently test cases are broken due to ecto dependecies 😑 , `mix test` and  `mix acceptance` commands will not work

#### To start application using Docker:

* Make sure Docker Deamon is up and running by verify with one of the commands `docker run hello-world` or `docker info`
* Navigate to the app root directory
* build the image by running `docker build -t tictac .`  don't forget to add a dot 
* `docker run -p 4000:4000 tictac`
* The game processor should be accessible now in `localhost:4000`.

## How to use the Game Processor

### Start a game

Game Processor provides an endpoint to start a game. You need to do a POST request to the following endpoint:
```
http://localhost:4000/api/v1/game/move
```
An example response will be in the form of unique gameId in UUID form:
```
{
  "game_id": "fdaee005-b595-4fc9-b30b-8a223da0ea57"
}
```

![game create api](https://contattafiles.s3.us-west-1.amazonaws.com/tnt35933/7QLZBhBaWaVFkUd/tictactoe-1621931180727.gif "Game create API")


Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
