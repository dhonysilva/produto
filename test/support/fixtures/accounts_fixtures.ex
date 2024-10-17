defmodule Produto.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Produto.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        full_name: "some full_name",
        role: "some role",
        username: "some username"
      })
      |> Produto.Accounts.create_user()

    user
  end
end
