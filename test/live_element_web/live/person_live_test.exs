defmodule LiveElementWeb.PersonLiveTest do
  use LiveElementWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveElement.PeopleFixtures

  @create_attrs %{birth_date: %{day: 13, month: 2, year: 2023}, feeling: "some feeling", name: "some name"}
  @update_attrs %{birth_date: %{day: 14, month: 2, year: 2023}, feeling: "some updated feeling", name: "some updated name"}
  @invalid_attrs %{birth_date: %{day: 30, month: 2, year: 2023}, feeling: nil, name: nil}

  defp create_person(_) do
    person = person_fixture()
    %{person: person}
  end

  describe "Index" do
    setup [:create_person]

    test "lists all people", %{conn: conn, person: person} do
      {:ok, _index_live, html} = live(conn, Routes.person_index_path(conn, :index))

      assert html =~ "Listing People"
      assert html =~ person.feeling
    end

    test "saves new person", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.person_index_path(conn, :index))

      assert index_live |> element("a", "New Person") |> render_click() =~
               "New Person"

      assert_patch(index_live, Routes.person_index_path(conn, :new))

      assert index_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#person-form", person: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.person_index_path(conn, :index))

      assert html =~ "Person created successfully"
      assert html =~ "some feeling"
    end

    test "updates person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, Routes.person_index_path(conn, :index))

      assert index_live |> element("#person-#{person.id} a", "Edit") |> render_click() =~
               "Edit Person"

      assert_patch(index_live, Routes.person_index_path(conn, :edit, person))

      assert index_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#person-form", person: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.person_index_path(conn, :index))

      assert html =~ "Person updated successfully"
      assert html =~ "some updated feeling"
    end

    test "deletes person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, Routes.person_index_path(conn, :index))

      assert index_live |> element("#person-#{person.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#person-#{person.id}")
    end
  end

  describe "Show" do
    setup [:create_person]

    test "displays person", %{conn: conn, person: person} do
      {:ok, _show_live, html} = live(conn, Routes.person_show_path(conn, :show, person))

      assert html =~ "Show Person"
      assert html =~ person.feeling
    end

    test "updates person within modal", %{conn: conn, person: person} do
      {:ok, show_live, _html} = live(conn, Routes.person_show_path(conn, :show, person))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Person"

      assert_patch(show_live, Routes.person_show_path(conn, :edit, person))

      assert show_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#person-form", person: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.person_show_path(conn, :show, person))

      assert html =~ "Person updated successfully"
      assert html =~ "some updated feeling"
    end
  end
end
