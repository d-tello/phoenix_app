defmodule PhoenixAppWeb.LogLive.FormComponent do
  use PhoenixAppWeb, :live_component

  alias PhoenixApp.Collections

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage log records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="log-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:ref_url]} type="text" label="Ref url" />
        <.input field={@form[:slug]} type="text" label="Slug" />
        <.input
          field={@form[:segments]}
          type="select"
          multiple
          label="Segments"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <.input
          field={@form[:audiences]}
          type="select"
          multiple
          label="Audiences"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <.input field={@form[:pet_type]} type="text" label="Pet type" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Log</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{log: log} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Collections.change_log(log))
     end)}
  end

  @impl true
  def handle_event("validate", %{"log" => log_params}, socket) do
    changeset = Collections.change_log(socket.assigns.log, log_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"log" => log_params}, socket) do
    save_log(socket, socket.assigns.action, log_params)
  end

  defp save_log(socket, :edit, log_params) do
    case Collections.update_log(socket.assigns.log, log_params) do
      {:ok, log} ->
        notify_parent({:saved, log})

        {:noreply,
         socket
         |> put_flash(:info, "Log updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_log(socket, :new, log_params) do
    case Collections.create_log(log_params) do
      {:ok, log} ->
        notify_parent({:saved, log})

        {:noreply,
         socket
         |> put_flash(:info, "Log created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
