defmodule Produto.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Produto.Blog` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        status: "some status",
        title: "some title"
      })
      |> Produto.Blog.create_post()

    post
  end
end
