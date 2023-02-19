defmodule LiveElement.PeopleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveElement.People` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        birth_date: ~D[2023-02-13],
        feeling: "some feeling",
        name: "some name"
      })
      |> LiveElement.People.create_person()

    person
  end
end
