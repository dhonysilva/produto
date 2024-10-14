defmodule ProdutoWeb.ProductLive.FormComponent do
  use ProdutoWeb, :live_component

  alias Produto.Catalog
  alias Produto.Catalog.Category

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:price]} type="number" label="Price" step="any" />
        <.input field={@form[:view]} type="number" label="View" />

        <h1 class="text-md font-semibold leading-8 text-zinc-800">
          Categories
        </h1>

        <div id="categories" class="space-y-2">
          <.inputs_for :let={category} field={@form[:categories]}>
            <div class="flex space-x-2 drag-item">
              <.input
                type="select"
                field={category[:category_id]}
                placeholder="Cotegory"
                options={@categories}
              />
            </div>
          </.inputs_for>
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    product_changeset = Catalog.change_product(product)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_product_form(product_changeset)
      |> assign_categories()
      # |> assign_new(:form, fn ->
      #   to_form(Catalog.change_product(product))
      # end)
    }
  end

  defp assign_categories(socket) do
    categories =
      Catalog.list_categories()
      |> Enum.map(&{&1.title, &1.id})

    assign(socket, :categories, categories)
  end

  def category_opts(changeset) do
    existing_ids =
      changeset
      |> Ecto.Changeset.get_change(:categories, [])
      |> Enum.map(& &1.data.id)

    for cat <- Catalog.list_categories(),
        do: [key: cat.title, value: cat.id, selected: cat.id in existing_ids]
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    # changeset = Catalog.change_product(socket.assigns.product, product_params)
    # {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_product_form(socket, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    case Catalog.update_product(socket.assigns.product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        # {:noreply, assign(socket, form: to_form(changeset))}
        {:noreply, assign_product_form(socket, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Catalog.create_product(product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        # {:noreply, assign(socket, form: to_form(changeset))}
        {:noreply, assign_product_form(socket, changeset)}
    end
  end

  defp assign_product_form(socket, %Ecto.Changeset{} = changeset) do
    if Ecto.Changeset.get_field(changeset, :categories) == [] do
      categories = %Category{}

      changeset = Ecto.Changeset.put_change(changeset, :categories, [categories])

      assign(socket, :form, to_form(changeset))
    else
      assign(socket, :form, to_form(changeset))
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
