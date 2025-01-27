defmodule Produto.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias Produto.Chat.Room

  schema "messages" do
    field :body, :string
    belongs_to :room, Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
