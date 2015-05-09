defmodule Spirit do

  defmacro __using__(_) do
    quote do
      use Plug.Router
      use Plug.ErrorHandler

      plug :match
      plug :dispatch

      def start do
        {:ok, _} = Plug.Adapters.Cowboy.http(__MODULE__, [], port: port)

        IO.puts "Running on http://localhost:#{port}"

        no_halt
      end

      defp iex_running? do
        Code.ensure_loaded?(IEx) && IEx.started?
      end

      defp no_halt do
        unless iex_running? do
          :timer.sleep :infinity
        end
      end

      defp port do
        System.get_env("PORT") || 4000
      end
    end
  end
end
