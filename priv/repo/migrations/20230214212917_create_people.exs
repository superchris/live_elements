defmodule LiveElement.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :name, :string
      add :feeling, :string
      add :birth_date, :date

      timestamps()
    end
  end
end
