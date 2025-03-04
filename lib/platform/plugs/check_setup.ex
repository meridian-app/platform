defmodule Platform.Plugs.CheckSetup do
  @moduledoc """
  Plug that checks whether the app is setup
  """
  import Plug.Conn
  import Phoenix.Controller

  alias Platform.Config

  @behaviour Plug

  @doc false
  @spec init(any()) :: any()
  def init(opts), do: opts

  def call(conn, _opts) do
    if Config.is_setup_completed?() do
      conn
    else
      conn
      |> put_flash(:error, "You need to setup meridian for your organization.")
      |> redirect(to: setup_path(conn))
      |> halt()
    end
  end

  defp setup_path(_conn), do: "/setup"
end
