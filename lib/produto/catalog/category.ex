defmodule Produto.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :title, :string

    many_to_many :products, Produto.Catalog.Product,
      join_through: "product_categories",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
