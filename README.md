
> "The simpler the food, the harder it is to prepare well" - Joël Robuchon.

# Tictactoe

Welcome to the TicTacToe Game Processor, an Elixir Phoenix API that manages a TicTacToe game. The App allows any type of client and provides a common interface to play a game.

## Main Technology stack

*  [Elixir](https://elixir-lang.org/)
*  [Phoenix](https://www.phoenixframework.org/)

## Deployment

Deployment has been done with one of the most popular PaaS [Heroku using the container stack](https://hexdocs.pm/phoenix/heroku.html).

> Note :  It might take up to 20 secs to get the API response first time, because Heroku unloads applications from the memory after some inactivity time and In-memory state such as those in Agents, GenServers, and ETS will be lost every 24 hours means a started game if not completed within 24 hours will be vanished.
See [Dyno Sleeping](https://devcenter.heroku.com/articles/free-dyno-hours#dyno-sleeping).

### App URL
https://tictac9.herokuapp.com

### Swagger API documenation URL

https://tictac9.herokuapp.com/api/v1/swagger

## Getting up and running:

#### To start application as a local Phoenix server:

  * Install Elixir from the [Elixir downloads page](https://elixir-lang.org/install.html).
  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`
  * The game processor should be accessible now in `localhost:4000`.
  * Currently test cases are broken due to ecto dependecies 😑. `mix test` and  `mix acceptance` commands will not work

#### To start the application using Docker:

* Make sure Docker Deamon is up and running by verify either of the two commands: `docker run hello-world` or `docker info`
* Navigate to the app root directory
* To run local docker image ,unfortunately `prod.secret.exs` require commenting line no 29 and uncomment line 28 to get the default port 😞 ( Due to heroku port accessing, working on finding a solution for this)
* build the image by running `docker build -t tictac .`  don't forget to add a dot 
* `docker run -p 4000:4000 tictac`
* The game processor should be accessible now in `localhost:4000`.

## How to use the Game Processor

### Start a game

Game Processor provides an endpoint to start a game. You need to do a POST request to the following endpoint:
```
http://localhost:4000/api/v1/game/create
```
An example response will be in the form of a unique gameId in UUID form:
```
{
  "game_id": "fdaee005-b595-4fc9-b30b-8a223da0ea57"
}
```

![game create api](https://contattafiles.s3.us-west-1.amazonaws.com/tnt35933/7QLZBhBaWaVFkUd/tictactoe-1621931180727.gif "Game create API")


### Performing a move.

Game Processor provides a way to get the player to move.

You need to do a POST operation to the following endpoint:

```
http://localhost:4000/api/v1/game/move
```
After this, you need to provide the specific parameters to move API as below in the request body. 

```
{
    
    "game_params" :{
        "game_id" : "080440c6-13b3-4e54-92d5-346dbc5b6511",
        "col" : 2,
        "row" : 3,
        "player" : "o"
    }
}
```
* `game_id`: Unique game Id generated by create game API 
* `col`: Board column number for a move, it should be within 1..3 range only 
* `row`: Board row number for a move, it should be within 1..3 range only 
* `player`: valid players are X and O, either uppercase or lower

#### Following checks will be validated by the game processor for the right move.

`lib/tictactoe_web/controllers/fallback_controller.ex` contains all the errors thrown by the game processor in case of an invalid move

* `game-Id`: A valid state game-id required for a move
* `player`: player passed must be X or O
* `cell coordinates`: row and column range should be 1..3 
* `cell occupied`: row and column should be empty for a proper move
* `player-turn`: The same player is not allowed in 2 consecutive moves 

A valid move response will contain the response.
```
{
  "board": {
    "{\"col\":1,\"row\":1}": "empty",
    "{\"col\":1,\"row\":2}": "empty",
    "{\"col\":1,\"row\":3}": "empty",
    "{\"col\":2,\"row\":1}": "empty",
    "{\"col\":2,\"row\":2}": "empty",
    "{\"col\":2,\"row\":3}": "o",
    "{\"col\":3,\"row\":1}": "empty",
    "{\"col\":3,\"row\":2}": "empty",
    "{\"col\":3,\"row\":3}": "empty"
  },
  "game_id": "1266eec6-8f95-4c3b-9473-46e3a41e955e",
  "player": "x",
  "winner": false
}
```
* The current board after the move.
* The player that performed the move as a value of cell coordinate value.
* The current game Id.
* Next player turn.

> If a move encounters a win or tie, an appropriate message would be displayed to encourage the players 🎉 


![game move api](https://contattafiles.s3.us-west-1.amazonaws.com/tnt35933/j88dMKfpDTLYc6A/tictactoe-1621936789185.gif "Game move API")

### Flow & Design

We need something fault-tolerant to ensure an error occurred in a game would be handled appropriately and not prevent the rest of the running games. 

 We need a tool that makes it easy to track the state of a game. By leveraging [Dynamic Supervisors](https://hexdocs.pm/elixir/1.12/DynamicSupervisor.html) and [GenServers](https://hexdocs.pm/elixir/GenServer.html), we can concurrently maintain lots and lots of games having an in-memory game state, gracefully handle any errors that might occur for a given game deployment and track each game process.

### App glossary

`GameSupervisor` :  A DynamicSupervisor which starts with no children. Children GameProcessors are started on demand. GameSupervisor allows players to start games, and it also automatically restarts them when a game process crashes. 

`GameProcessor` : Its a GenServer to keep each game’s state. With our GenServer callbacks in place, we can spawn a process that maintains a game’s state.

`GameRegistry` : 
We can’t name a process with a string; we need to use a [Registry](https://hexdocs.pm/elixir/master/Registry.html) to link string names to game PID's. Elixir’s GenServer implementation has a built-in way of referring to processes in a registry through it’s :via-tuples

`State` : Managing and manipulating a perticular game state , exe :initial,:playing,:game_over etc , leveraging the power of [Elixir pattern maching](https://elixir-lang.org/getting-started/pattern-matching.html)

`GameStore` : In-memory Map to store a game state, can be easily replaced by a persistance data store like **postgres**

![App diagram](https://contattafiles.s3.us-west-1.amazonaws.com/tnt35933/y1rZc5KimgiBVvd/unchain-tictac.jpg "App architecture")


### Further improvements & TODO:
* More test cases for sure 😔
* MiniMax Algorithm for a computer player
* A frontend client in Angular,React or Vue
* Pub Sub design for real time game state update using web sockets
* Phoenix live view dashboard 
* Further code optimization and modularization
* Detailed module and function documentation


## Resources followed for assignment and Elixir learning

  * Elixir in Action: https://www.manning.com/books/elixir-in-action-second-edition
  * Alchemist Camp: https://www.youtube.com/channel/UCp5Nix6mJCoLkH_GqcRRp1A
  * Elixir School: https://elixirschool.com/
  * jessejanderson: https://gist.github.com/jessejanderson/26ef3cf17017e38af7e76bd2dcc6cfb0
  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

### Add on

> Bored of being bored because being bored is boring.

Utilizing the App's modular design like  State, GameProcessor, GameUtils etc., a CLI module allows you to play Tictactoe in the command line.

* open terminal in app's root dir
* type `iex -s mix`
* import CLI module `import Tictactoe.Game.Cli`
* just type `play`

> Note : As this module does not use GenServer for state management, any error will restart the game.

![CLI module](https://contattafiles.s3.us-west-1.amazonaws.com/tnt35933/fFvIhXvMKY5Vr6H/tictactoe-1621955308465.gif "CLI Tictactoe")