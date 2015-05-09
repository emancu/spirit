defmodule Mix.Tasks.Server do
  use Mix.Task

  def run(_args) do
    { :ok, app } = :application.get_env(:spirit, :app)

    app.start
  end
end
