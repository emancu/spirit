Spirit
======

n. a microframework for web development.

## Description

We are big fans of [cuba] for `ruby` so we wanted to contribute to `elixir`
community with a similar microframework.

The intention of this project is to learn how `elixir` works and create a
framework for our upcoming projects.

We know there are many frameworks like [phoenix], [clint], [sugar] and others
which we will be watching to learn and contribute but we still want to build
a new one. It will teach us a lot!

## Installation

Add `:spirit` to deps

```elixir
defp deps do
  [
    { :spirit, "~> 0.0.1" }
  ]
end
```

And run `mix do deps.get, deps.compile`

## Usage

Here's a simple application:

```elixir
# cat lib/sample_app.ex

defmodule SampleApp do
  use Spirit

  get "/hello" do
    send_resp(conn, 200, "<h1>Hello World!</h1>")
  end

  match _ do
    send_resp(conn, 404, "Not found :/")
  end
end
```

And the config file

```elixir
# cat config/config.exs

use Mix.Config

config :spirit, app: SampleApp
```

To run it, just do `mix server` and start browsing your application.

> Check [spirit-example] to see the full example and step-by-step guide.

## Composition

You can compose as many Spirit applications as you want using `forward`.
This is a recommended practice when you have nested routes or want to group
routes based on a criterion.

```elixir
defmodule Users do
  use Spirit

  get "/" do
    send_resp(conn, 200, "Users index")
  end

  get "/:id" do
    # Show the User with `id`
  end

  post "/" do
    # Create a new user
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end

defmodule MainApp do
  use Spirit

  get "/hi/:name" do
    send_resp(conn, 200, "<h1>hello #{name}!</h1>")
  end

  forward "/users", to: Users

  get "/hello/*_rest" do
    send_resp(conn, 200, "matches all routes starting with /hello")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
```


[cuba]: https://github.com/soveran/cuba
[clint]: https://github.com/lpil/clint
[sugar]: http://sugar-framework.github.io
[phoenix]: http://phoenixframework.org
[spirit-example]: https://github.com/citrusbyte/spirit-example
