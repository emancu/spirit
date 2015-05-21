defmodule Spirit do

  defmacro __using__(_) do
    quote do
      use Plug.Router
      use Plug.ErrorHandler

      plug :fetch_query_params
      plug Plug.Parsers, parsers: [:urlencoded, :json, :multipart],
        pass:  ["*/*"],
        json_decoder: Poison

      plug :match
      plug :dispatch

      def start do
        {:ok, _} = Plug.Adapters.Cowboy.http(__MODULE__, [], port: port)

        IO.puts "Running on http://localhost:#{port}"

        no_halt
      end

      @doc """
      Redirects the response.
      ## Arguments
      * `conn` - `Plug.Conn`
      * `location` - `String`
      * `opts` - `Keyword`

      ## Returns
      `Plug.Conn`
      """
      @spec redirect(Plug.Conn.t, binary, Keyword.t) :: Plug.Conn.t
      def redirect(conn, location, opts \\ [])

      def redirect(%Plug.Conn{state: :sent} = conn, _, _) do
        conn
      end

      def redirect(conn, location, opts \\ []) do
        opts = [status: 302] |> Keyword.merge(opts)

        conn
        |> put_resp_header("Location", location)
        |> send_resp(opts[:status], "")
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
