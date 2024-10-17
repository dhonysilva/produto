defmodule Produto.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :full_name, :string
      add :email, :string
      add :role, :string

      timestamps(type: :utc_datetime)
    end

    create index(:users, [:username])
    create index(:users, [:email], unique: true)
  end
end
