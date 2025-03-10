defmodule PlatformWeb.UsersRegistrationLiveTest do
  use PlatformWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Platform.AccountsFixtures

  describe "Registration page" do
    test "renders registration page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/identity/signup")

      assert html =~ "Register"
      assert html =~ "Log in"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_users(users_fixture())
        |> live(~p"/identity/signup")
        |> follow_redirect(conn, "/")

      assert {:ok, _conn} = result
    end

    test "renders errors for invalid data", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/identity/signup")

      result =
        lv
        |> element("#registration_form")
        |> render_change(users: %{"email" => "with spaces", "password" => "too short"})

      assert result =~ "Register"
      assert result =~ "must have the @ sign and no spaces"
      assert result =~ "should be at least 12 character"
    end
  end

  describe "register users" do
    test "creates account and logs the users in", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/identity/signup")

      email = unique_users_email()
      form = form(lv, "#registration_form", users: valid_users_attributes(email: email))
      render_submit(form)
      conn = follow_trigger_action(form, conn)

      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings"
      assert response =~ "Log out"
    end

    test "renders errors for duplicated email", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/identity/signup")

      users = users_fixture(%{email: "test@email.com"})

      result =
        lv
        |> form("#registration_form",
          users: %{"email" => users.email, "password" => "valid_password"}
        )
        |> render_submit()

      assert result =~ "has already been taken"
    end
  end

  describe "registration navigation" do
    test "redirects to login page when the Log in button is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/identity/signup")

      {:ok, _login_live, login_html} =
        lv
        |> element(~s|main a:fl-contains("Log in")|)
        |> render_click()
        |> follow_redirect(conn, ~p"/identity/login")

      assert login_html =~ "Log in"
    end
  end
end
