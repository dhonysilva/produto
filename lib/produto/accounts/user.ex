defmodule Produto.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :role, :string
    field :username, :string
    field :full_name, :string
    field :email, :string

    has_many :posts, Produto.Blog.Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :full_name, :email, :role])
    |> cast_assoc(:posts)
    |> validate_required([:username, :full_name, :email, :role])
    |> unique_constraint([:email])
  end
end
