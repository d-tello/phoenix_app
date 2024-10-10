defmodule PhoenixAppWeb.LogLive.Index do
  use PhoenixAppWeb, :live_view

  alias PhoenixApp.Collections
  alias PhoenixApp.Collections.Log

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :collections_logs, Collections.list_collections_logs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Log")
    |> assign(:log, Collections.get_log!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Log")
    |> assign(:log, %Log{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Collections logs")
    |> assign(:log, nil)
  end

  @impl true
  def handle_info({PhoenixAppWeb.LogLive.FormComponent, {:saved, log}}, socket) do
    {:noreply, stream_insert(socket, :collections_logs, log)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    log = Collections.get_log!(id)
    {:ok, _} = Collections.delete_log(log)

    {:noreply, stream_delete(socket, :collections_logs, log)}
  end
end
