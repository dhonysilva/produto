defmodule Produto.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :title, :string
    field :price, :decimal
    field :view, :integer

    many_to_many :categories, Produto.Catalog.Category,
      join_through: "product_categories",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description, :price, :view])
    |> validate_required([:title, :description, :price, :view])
  end
end