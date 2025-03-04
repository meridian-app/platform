defmodule PlatformWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use PlatformWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint PlatformWeb.Endpoint

      use PlatformWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import PlatformWeb.ConnCase
    end
  end

  setup tags do
    Platform.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in user.

      setup :register_and_log_in_users

  It stores an updated connection and a registered users in the
  test context.
  """
  def register_and_log_in_users(%{conn: conn}) do
    users = Platform.AccountsFixtures.users_fixture()
    %{conn: log_in_users(conn, users), users: users}
  end

  @doc """
  Logs the given `users` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_users(conn, users) do
    token = Platform.Accounts.generate_users_session_token(users)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:users_token, token)
  end
end
