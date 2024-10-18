defmodule PhoenixAppWeb.LogLive.Index do
  use PhoenixAppWeb, :live_view

  alias PhoenixApp.Collections
  alias PhoenixApp.Collections.Log
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    fromDate = Timex.shift(Timex.now(), days: -30) |> Timex.format!("%Y-%m-%d", :strftime)
    toDate = Timex.now() |> Timex.format!("%Y-%m-%d", :strftime)
    rowsPerPage = 10

    # Convert date strings to DateTime structs
    fromDateTime =
      Timex.parse!(fromDate <> " 00:00:00", "{YYYY}-{0M}-{0D} {h24}:{m}:{s}")
      |> Timex.to_datetime()

    toDateTime =
      Timex.parse!(toDate <> " 23:59:59", "{YYYY}-{0M}-{0D} {h24}:{m}:{s}") |> Timex.to_datetime()

    logsStats = Collections.list_logs_stats(fromDateTime, toDateTime, rowsPerPage)

    socket =
      assign(socket,
        fromDate: fromDate,
        toDate: toDate,
        rowsPerPage: rowsPerPage,
        collectionsLogs: logsStats
      )

    {:ok, stream(socket, :collections_logs, logsStats)}
  end

  @impl true
  @spec handle_params(any(), any(), map()) :: {:noreply, map()}
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    log = Collections.get_log!(id)

    socket
    |> assign(:page_title, "Edit Log")
    |> assign(:log, log)
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
  @spec handle_info(
          {PhoenixAppWeb.LogLive.FormComponent, {:saved, any()}},
          Phoenix.LiveView.Socket.t()
        ) :: {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_info({PhoenixAppWeb.LogLive.FormComponent, {:saved, log}}, socket) do
    {:noreply, stream_insert(socket, :collections_logs, log)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    log = Collections.get_log!(id)
    {:ok, _} = Collections.delete_log(log)

    {:noreply, stream_delete(socket, :collections_logs, log)}
  end

  @impl true
  def handle_event(
        "handle_form_change",
        %{"fromDate" => fromDate, "toDate" => toDate, "rowsPerPage" => rowsPerPage},
        socket
      ) do
    rowsPerPage = String.to_integer(rowsPerPage)

    # Convert date strings to DateTime structs
    fromDateTime =
      Timex.parse!(fromDate <> " 00:00:00", "{YYYY}-{0M}-{0D} {h24}:{m}:{s}")
      |> Timex.to_datetime()

    toDateTime =
      Timex.parse!(toDate <> " 23:59:59", "{YYYY}-{0M}-{0D} {h24}:{m}:{s}") |> Timex.to_datetime()

    logsStats = Collections.list_logs_stats(fromDateTime, toDateTime, rowsPerPage)

    {:noreply,
     assign(socket,
       fromDate: fromDate,
       toDate: toDate,
       rowsPerPage: rowsPerPage,
       collectionsLogs: logsStats
     )}
  end
end
