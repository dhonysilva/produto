defmodule Produto.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Produto.Accounts.User

  schema "posts" do
    field :status, :string
    field :title, :string
    field :body, :string
    belongs_to :user, Produto.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :status, :user_id])
    |> validate_required([:title, :body, :status, :user_id])
    |> cast_assoc(:user, with: &User.changeset/2)
  end
end
