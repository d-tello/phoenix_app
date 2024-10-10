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
    fromDateTime = Timex.parse!(fromDate <> " 00:00:00", "{YYYY}-{0M}-{0D} {h24}:{m}:{s}") |> Timex.to_datetime()
    toDateTime = Timex.parse!(toDate <> " 23:59:59", "{YYYY}-{0M}-{0D} {h24}:{m}:{s}") |> Timex.to_datetime()

    logsStats = Collections.list_logs_stats(fromDateTime, toDateTime, rowsPerPage)
    socket = stream_configure(socket, :collections_logs, dom_id: &(&1.slug))
    socket = assign(socket, fromDate: fromDate, toDate: toDate, rowsPerPage: rowsPerPage, collectionsLogs: logsStats)
    {:ok, stream(socket, :collections_logs, logsStats)}
  end

  @impl true
  @spec handle_params(any(), any(), map()) :: {:noreply, map()}
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Log")
    |> assign(:log, Collections.get_log_by_slug!(id))
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
  def handle_event("update_dates", %{"fromDate" => fromDate, "toDate" => toDate}, socket) do
    Logger.info("Event triggered: update_dates")
    Logger.info("Updating dates: fromDate=#{fromDate}, toDate=#{toDate}")

    # Convert date strings to DateTime structs
    fromDateTime = Timex.parse!(fromDate <> " 00:00:00", "{YYYY}-{0M}-{0D} {h24}:{m}:{s}") |> Timex.to_datetime()
    toDateTime = Timex.parse!(toDate <> " 23:59:59", "{YYYY}-{0M}-{0D} {h24}:{m}:{s}") |> Timex.to_datetime()

    logsStats = Collections.list_logs_stats(fromDateTime, toDateTime, socket.assigns.rowsPerPage)
    Logger.info("Logs Stats: #{inspect(logsStats)}")
    {:noreply, assign(socket, fromDate: fromDate, toDate: toDate, collectionsLogs: logsStats)}
  end

  @impl true
  def handle_event("update_rows_per_page", %{"rowsPerPage" => rowsPerPage}, socket) do
    rowsPerPage = String.to_integer(rowsPerPage)
    Logger.info("Event triggered: update_rows_per_page")
    Logger.info("Updating rows per page: rowsPerPage=#{rowsPerPage}")

    # Convert date strings to DateTime structs
    fromDateTime = Timex.parse!(socket.assigns.fromDate <> " 00:00:00", "{YYYY}-{0M}-{0D} {h24}:{m}:{s}") |> Timex.to_datetime()
    toDateTime = Timex.parse!(socket.assigns.toDate <> " 23:59:59", "{YYYY}-{0M}-{0D} {h24}:{m}:{s}") |> Timex.to_datetime()

    logsStats = Collections.list_logs_stats(fromDateTime, toDateTime, rowsPerPage)
    Logger.info("Logs Stats: #{inspect(logsStats)}")
    {:noreply, assign(socket, rowsPerPage: rowsPerPage, collectionsLogs: logsStats)}
  end
end
