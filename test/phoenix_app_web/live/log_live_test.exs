defmodule PhoenixAppWeb.LogLiveTest do
  use PhoenixAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import PhoenixApp.CollectionsFixtures

  @create_attrs %{ref_url: "some ref_url", slug: "some slug", segments: ["option1", "option2"], audiences: ["option1", "option2"], pet_type: "some pet_type"}
  @update_attrs %{ref_url: "some updated ref_url", slug: "some updated slug", segments: ["option1"], audiences: ["option1"], pet_type: "some updated pet_type"}
  @invalid_attrs %{ref_url: nil, slug: nil, segments: [], audiences: [], pet_type: nil}

  defp create_log(_) do
    log = log_fixture()
    %{log: log}
  end

  describe "Index" do
    setup [:create_log]

    test "lists all collections_logs", %{conn: conn, log: log} do
      {:ok, _index_live, html} = live(conn, ~p"/collections_logs")

      assert html =~ "Listing Collections logs"
      assert html =~ log.ref_url
    end

    test "saves new log", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/collections_logs")

      assert index_live |> element("a", "New Log") |> render_click() =~
               "New Log"

      assert_patch(index_live, ~p"/collections_logs/new")

      assert index_live
             |> form("#log-form", log: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#log-form", log: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/collections_logs")

      html = render(index_live)
      assert html =~ "Log created successfully"
      assert html =~ "some ref_url"
    end

    test "updates log in listing", %{conn: conn, log: log} do
      {:ok, index_live, _html} = live(conn, ~p"/collections_logs")

      assert index_live |> element("#collections_logs-#{log.id} a", "Edit") |> render_click() =~
               "Edit Log"

      assert_patch(index_live, ~p"/collections_logs/#{log}/edit")

      assert index_live
             |> form("#log-form", log: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#log-form", log: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/collections_logs")

      html = render(index_live)
      assert html =~ "Log updated successfully"
      assert html =~ "some updated ref_url"
    end

    test "deletes log in listing", %{conn: conn, log: log} do
      {:ok, index_live, _html} = live(conn, ~p"/collections_logs")

      assert index_live |> element("#collections_logs-#{log.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#collections_logs-#{log.id}")
    end
  end

  describe "Show" do
    setup [:create_log]

    test "displays log", %{conn: conn, log: log} do
      {:ok, _show_live, html} = live(conn, ~p"/collections_logs/#{log}")

      assert html =~ "Show Log"
      assert html =~ log.ref_url
    end

    test "updates log within modal", %{conn: conn, log: log} do
      {:ok, show_live, _html} = live(conn, ~p"/collections_logs/#{log}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Log"

      assert_patch(show_live, ~p"/collections_logs/#{log}/show/edit")

      assert show_live
             |> form("#log-form", log: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#log-form", log: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/collections_logs/#{log}")

      html = render(show_live)
      assert html =~ "Log updated successfully"
      assert html =~ "some updated ref_url"
    end
  end
end
