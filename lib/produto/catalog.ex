defmodule Produto.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias Produto.Repo

  alias Produto.Catalog.Product
  alias Produto.Catalog.Category

  def list_products do
    Repo.all(Product)
  end

  def get_product!(id) do
    Product
    |> Repo.get!(id)
    |> Repo.preload(:categories)
  end

  def create_product(attrs \\ %{}) do
    IO.puts("Handling 'update_product' event and saving product record.")
    IO.inspect(attrs)

    %Product{}
    # |> Product.changeset(attrs)
    |> change_product(attrs)
    |> Repo.insert()
  end

  def update_product(%Product{} = product, attrs) do
    IO.puts("Handling 'update_product' event and saving product record.")
    IO.inspect(product)

    product
    # |> Product.changeset(attrs)
    |> change_product(attrs)
    |> Repo.update()
  end

  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def change_product(%Product{} = product, attrs \\ %{}) do
    IO.puts("Handling 'change_product' event and saving product record.")
    IO.inspect(product)
    # Product.changeset(product, attrs)
    categories = list_categories_by_id(attrs["category_id"])

    product
    |> Repo.preload(:categories)
    |> Product.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:categories, categories)
  end

  def list_categories_by_id(nil), do: []

  def list_categories_by_id(category_id) do
    Repo.all(from c in Category, where: c.id in ^category_id)
  end

  def list_categories do
    Repo.all(Category)
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
