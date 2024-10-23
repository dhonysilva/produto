defmodule ProdutoWeb.PostLive.FormComponent do
  use ProdutoWeb, :live_component

  alias Produto.Blog
  alias Produto.Accounts
  alias Produto.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage post records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="post-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:body]} type="textarea" label="Body" />
        <.input field={@form[:status]} type="text" label="Status" />
        <.input
          field={@form[:user_id]}
          type="select"
          label="Author"
          prompt="Select an owner"
          options={@users}
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Post</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{post: post} = assigns, socket) do
    post_changeset = Blog.change_post(post)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_users()
      |> assign_form(post_changeset)
      # |> assign_new(:form, fn ->
      #   to_form(Blog.change_post(post))
      # end)
    }
  end

  defp assign_users(socket) do
    users =
      Accounts.list_users()
      |> Enum.map(&{&1.username, &1.id})

    assign(socket, :users, users)
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset = Blog.change_post(socket.assigns.post, post_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    IO.puts("passando no handle_event save")
    IO.inspect(post_params)
    save_post(socket, socket.assigns.action, post_params)
  end

  defp save_post(socket, :edit, post_params) do
    case Blog.update_post(socket.assigns.post, post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_post(socket, :new, post_params) do
    IO.puts("passando no save_post :new")
    IO.inspect(post_params)

    case Blog.create_post(post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    if Ecto.Changeset.get_field(changeset, :user) == [] do
      users = %User{}

      changeset = Ecto.Changeset.put_change(changeset, :user, [users])

      assign(socket, :form, to_form(changeset))
    else
      assign(socket, :form, to_form(changeset))
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
