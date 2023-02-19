defmodule LiveElement.People.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :birth_date, :date
    field :feeling, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :feeling, :birth_date])
    |> validate_required([:name, :feeling, :birth_date])
  end
end
